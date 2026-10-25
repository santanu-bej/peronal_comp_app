package com.teqsonic.goalcompass.usage

import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import com.teqsonic.goalcompass.store.NativeStore
import org.json.JSONArray
import org.json.JSONObject

/**
 * UsageStatsManager events → [{pkg,start,end}]. Sessions < 3 s are dropped; open sessions are closed
 * at SCREEN_NON_INTERACTIVE. A session still open at [to] is emitted up to [to] and carried over so
 * the next read continues it (no lost time between 15-minute reads).
 */
object UsageReader {
    private const val SCREEN_NON_INTERACTIVE = 17
    private const val RESUMED = 1 // ACTIVITY_RESUMED == MOVE_TO_FOREGROUND
    private const val PAUSED = 2 // ACTIVITY_PAUSED == MOVE_TO_BACKGROUND

    fun read(ctx: Context, from: Long, to: Long): String {
        val usm = ctx.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val prefs = NativeStore.prefs(ctx)
        var carry: String? = prefs.getString("usage_carry", null)
        val out = JSONArray()
        val open = HashMap<String, Long>()
        if (carry != null) open[carry] = from

        fun close(pkg: String, end: Long) {
            val start = open.remove(pkg) ?: return
            if (end - start >= 3000) out.put(JSONObject().put("pkg", pkg).put("start", start).put("end", end))
        }

        val ev = usm.queryEvents(from, to)
        val e = UsageEvents.Event()
        while (ev.hasNextEvent()) {
            ev.getNextEvent(e)
            val pkg = e.packageName ?: continue
            when (e.eventType) {
                RESUMED -> {
                    // only one foreground app at a time
                    open.keys.toList().filter { it != pkg }.forEach { close(it, e.timeStamp) }
                    if (!open.containsKey(pkg)) open[pkg] = e.timeStamp
                }
                PAUSED -> close(pkg, e.timeStamp)
                SCREEN_NON_INTERACTIVE -> open.keys.toList().forEach { close(it, e.timeStamp) }
            }
        }
        // carry the still-open session; emit what we have so far
        carry = open.keys.firstOrNull()
        open.entries.toList().forEach { (pkg, start) ->
            if (to - start >= 3000) out.put(JSONObject().put("pkg", pkg).put("start", start).put("end", to))
        }
        prefs.edit().apply { if (carry == null) remove("usage_carry") else putString("usage_carry", carry) }.apply()
        return out.toString()
    }
}
