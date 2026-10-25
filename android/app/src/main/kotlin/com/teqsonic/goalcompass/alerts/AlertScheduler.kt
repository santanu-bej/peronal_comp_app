package com.teqsonic.goalcompass.alerts

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import com.teqsonic.goalcompass.store.EventQueue
import com.teqsonic.goalcompass.store.NativeStore
import com.teqsonic.goalcompass.store.TAG
import com.teqsonic.goalcompass.store.forEachObject
import org.json.JSONArray
import org.json.JSONObject

/**
 * Todo reminders, daily focus, stage-due. Full replacement on every sync; stored as JSON in NativeStore.
 * One PendingIntent per alert id (data = goalcompass://alert/<id>).
 */
object AlertScheduler {
    private const val KEY = "alerts"
    private const val FIRED = "alerts_fired"
    private const val MISSED_WINDOW_MS = 24 * 3600_000L

    private fun pi(ctx: Context, id: String, create: Boolean = true): PendingIntent? {
        val i = Intent(ctx, AlertReceiver::class.java).apply {
            data = Uri.parse("goalcompass://alert/${Uri.encode(id)}")
            putExtra("id", id)
        }
        val flags = PendingIntent.FLAG_IMMUTABLE or (if (create) PendingIntent.FLAG_UPDATE_CURRENT else PendingIntent.FLAG_NO_CREATE)
        return PendingIntent.getBroadcast(ctx, id.hashCode(), i, flags)
    }

    fun canExact(ctx: Context): Boolean {
        if (Build.VERSION.SDK_INT < 31) return true
        return ctx.getSystemService(AlarmManager::class.java).canScheduleExactAlarms()
    }

    private fun arm(ctx: Context, id: String, atMs: Long) {
        val am = ctx.getSystemService(AlarmManager::class.java)
        val p = pi(ctx, id)!!
        try {
            if (canExact(ctx)) am.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, atMs, p)
            else am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, atMs, p)
        } catch (e: SecurityException) {
            am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, atMs, p)
        }
    }

    private fun cancel(ctx: Context, id: String) {
        pi(ctx, id, create = false)?.let {
            ctx.getSystemService(AlarmManager::class.java).cancel(it)
            it.cancel()
        }
    }

    /** Replace all alerts. Cancels anything not in the new list, arms the rest. */
    fun sync(ctx: Context, json: String) {
        val old = NativeStore.array(ctx, KEY)
        val new = try { JSONArray(json) } catch (e: Exception) { JSONArray() }
        val newIds = HashSet<String>()
        new.forEachObject { newIds.add(it.optString("id")) }
        old.forEachObject { o -> if (o.optString("id") !in newIds) cancel(ctx, o.optString("id")) }
        NativeStore.putJson(ctx, KEY, new.toString())
        val fired = firedSet(ctx)
        val now = System.currentTimeMillis()
        new.forEachObject { o ->
            val id = o.optString("id")
            val at = o.optLong("atMs")
            if (id.isEmpty()) return@forEachObject
            if (at > now) arm(ctx, id, at) else if (id !in fired && at > now - MISSED_WINDOW_MS) {
                // alert time passed while the sync was pending: fire promptly (missed → once)
                fired.add(id)
                AlertReceiver.show(ctx, o, missed = true)
            }
        }
        saveFired(ctx, fired.filter { it in newIds }.toSet())
        EventQueue.log(ctx, "alert", "Synced ${new.length()} alerts")
        Log.i(TAG, "alerts synced: ${new.length()}")
    }

    fun find(ctx: Context, id: String): JSONObject? {
        var r: JSONObject? = null
        NativeStore.array(ctx, KEY).forEachObject { if (it.optString("id") == id) r = it }
        return r
    }

    fun markFired(ctx: Context, id: String) {
        val s = firedSet(ctx)
        s.add(id)
        saveFired(ctx, s)
    }

    /** Re-time a single alert (snooze) and arm it. */
    fun reschedule(ctx: Context, id: String, atMs: Long) {
        val arr = NativeStore.array(ctx, KEY)
        var found = false
        arr.forEachObject { if (it.optString("id") == id) { it.put("atMs", atMs); found = true } }
        if (!found) return
        NativeStore.putJson(ctx, KEY, arr.toString())
        val s = firedSet(ctx); s.remove(id); saveFired(ctx, s)
        arm(ctx, id, atMs)
    }

    /** One-shot alert not coming from Dart (tests). */
    fun scheduleTest(ctx: Context, seconds: Int) {
        val id = "test:${System.currentTimeMillis()}"
        val arr = NativeStore.array(ctx, KEY)
        arr.put(JSONObject().put("id", id).put("atMs", System.currentTimeMillis() + seconds * 1000L).put("title", "Test alert · score 90").put("body", "If you see this over another app, banners work.").put("kind", "reminder").put("deepLink", "goalcompass://todos"))
        NativeStore.putJson(ctx, KEY, arr.toString())
        arm(ctx, id, System.currentTimeMillis() + seconds * 1000L)
    }

    /** After reboot / app update / time change: re-arm all future alerts; missed ones fire once. */
    fun rearm(ctx: Context) {
        val fired = firedSet(ctx)
        val now = System.currentTimeMillis()
        NativeStore.array(ctx, KEY).forEachObject { o ->
            val id = o.optString("id")
            val at = o.optLong("atMs")
            if (at > now) arm(ctx, id, at)
            else if (id !in fired && at > now - MISSED_WINDOW_MS) {
                fired.add(id)
                AlertReceiver.show(ctx, o, missed = true)
            }
        }
        saveFired(ctx, fired)
        EventQueue.log(ctx, "alert", "Alerts re-armed")
    }

    private fun firedSet(ctx: Context): MutableSet<String> =
        NativeStore.prefs(ctx).getStringSet(FIRED, emptySet())!!.toMutableSet()

    private fun saveFired(ctx: Context, s: Set<String>) {
        NativeStore.prefs(ctx).edit().putStringSet(FIRED, s).apply()
    }
}
