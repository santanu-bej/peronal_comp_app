package com.teqsonic.goalcompass.wake

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.util.Log
import com.teqsonic.goalcompass.MainActivity
import com.teqsonic.goalcompass.escalate.EscalationReceiver
import com.teqsonic.goalcompass.store.EventQueue
import com.teqsonic.goalcompass.store.NativeStore
import com.teqsonic.goalcompass.store.TAG
import com.teqsonic.goalcompass.store.forEachObject
import org.json.JSONArray
import org.json.JSONObject
import java.time.DayOfWeek
import java.time.LocalTime
import java.time.ZoneId
import java.time.ZonedDateTime

/**
 * Wake alarms use AlarmManager.setAlarmClock (exits Doze, shows the alarm icon). Escalation is a
 * second setAlarmClock at ring + grace, so it fires with the app killed.
 */
object WakeScheduler {
    private const val KEY = "wake_items"
    private val zone: ZoneId = ZoneId.of("Asia/Kolkata")

    fun items(ctx: Context): JSONArray = NativeStore.array(ctx, KEY)

    fun find(ctx: Context, id: String): JSONObject? {
        var r: JSONObject? = null
        items(ctx).forEachObject { if (it.optString("id") == id) r = it }
        return r
    }

    private fun ringPi(ctx: Context, id: String, snooze: Boolean = false, create: Boolean = true): PendingIntent? {
        val i = Intent(ctx, WakeReceiver::class.java).apply {
            data = Uri.parse("goalcompass://wake/${if (snooze) "snooze" else "ring"}/${Uri.encode(id)}")
            putExtra("id", id)
            putExtra("snooze", snooze)
        }
        val flags = PendingIntent.FLAG_IMMUTABLE or (if (create) PendingIntent.FLAG_UPDATE_CURRENT else PendingIntent.FLAG_NO_CREATE)
        return PendingIntent.getBroadcast(ctx, ("ring" + snooze + id).hashCode(), i, flags)
    }

    private fun escPi(ctx: Context, id: String, create: Boolean = true): PendingIntent? {
        val i = Intent(ctx, EscalationReceiver::class.java).apply {
            data = Uri.parse("goalcompass://wake/escalate/${Uri.encode(id)}")
            putExtra("id", id)
        }
        val flags = PendingIntent.FLAG_IMMUTABLE or (if (create) PendingIntent.FLAG_UPDATE_CURRENT else PendingIntent.FLAG_NO_CREATE)
        return PendingIntent.getBroadcast(ctx, ("esc$id").hashCode(), i, flags)
    }

    private fun showIntent(ctx: Context): PendingIntent =
        PendingIntent.getActivity(ctx, 77, Intent(ctx, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)

    fun setClock(ctx: Context, at: Long, pi: PendingIntent) {
        val am = ctx.getSystemService(AlarmManager::class.java)
        try {
            am.setAlarmClock(AlarmManager.AlarmClockInfo(at, showIntent(ctx)), pi)
        } catch (e: SecurityException) {
            am.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, at, pi)
        }
    }

    /** Next ring time (ms) for HH:mm and days mask (bit0 = Mon), strictly after [after]. */
    fun nextRing(hhmm: String, daysMask: Int, after: Long = System.currentTimeMillis()): Long? {
        if (daysMask and 0x7F == 0) return null
        val p = hhmm.split(":")
        val t = LocalTime.of(p[0].toInt(), p[1].toInt())
        var d = ZonedDateTime.ofInstant(java.time.Instant.ofEpochMilli(after), zone).toLocalDate()
        for (k in 0..7) {
            val dow = d.dayOfWeek.value - DayOfWeek.MONDAY.value // 0 = Mon
            if ((daysMask shr dow) and 1 == 1) {
                val at = ZonedDateTime.of(d, t, zone).toInstant().toEpochMilli()
                if (at > after) return at
            }
            d = d.plusDays(1)
        }
        return null
    }

    /** Replace all wake routines: cancel everything, arm the next ring of each enabled routine. */
    fun sync(ctx: Context, json: String) {
        val old = items(ctx)
        old.forEachObject { cancelAll(ctx, it.optString("id")) }
        val new = try { JSONArray(json) } catch (e: Exception) { JSONArray() }
        NativeStore.putJson(ctx, KEY, new.toString())
        new.forEachObject { if (it.optBoolean("enabled", true)) armNext(ctx, it) }
        EventQueue.log(ctx, "wake", "Wake routines synced (${new.length()})")
    }

    fun armNext(ctx: Context, item: JSONObject) {
        val id = item.optString("id")
        val at = nextRing(item.optString("hhmm", "06:30"), item.optInt("daysMask", 127)) ?: return
        setClock(ctx, at, ringPi(ctx, id)!!)
        Log.i(TAG, "wake $id armed for $at")
    }

    fun rearm(ctx: Context) {
        items(ctx).forEachObject { if (it.optBoolean("enabled", true)) armNext(ctx, it) }
        // an escalation pending while the phone rebooted: ringing state is gone, drop it
        WakeState.clearAll(ctx)
    }

    fun scheduleSnooze(ctx: Context, id: String, at: Long) = setClock(ctx, at, ringPi(ctx, id, snooze = true)!!)
    fun scheduleEscalation(ctx: Context, id: String, at: Long) = setClock(ctx, at, escPi(ctx, id)!!)

    fun cancelEscalation(ctx: Context, id: String) {
        escPi(ctx, id, create = false)?.let { ctx.getSystemService(AlarmManager::class.java).cancel(it); it.cancel() }
    }

    fun cancelAll(ctx: Context, id: String) {
        val am = ctx.getSystemService(AlarmManager::class.java)
        ringPi(ctx, id, false, create = false)?.let { am.cancel(it); it.cancel() }
        ringPi(ctx, id, true, create = false)?.let { am.cancel(it); it.cancel() }
        cancelEscalation(ctx, id)
        WakeState.clear(ctx, id)
    }
}

/** Per-routine ringing state (survives process death). */
object WakeState {
    private fun p(ctx: Context) = NativeStore.prefs(ctx)

    fun get(ctx: Context, id: String): JSONObject = try { JSONObject(p(ctx).getString("wake_state_$id", "{}")) } catch (e: Exception) { JSONObject() }
    fun put(ctx: Context, id: String, o: JSONObject) = p(ctx).edit().putString("wake_state_$id", o.toString()).apply()
    fun clear(ctx: Context, id: String) = p(ctx).edit().remove("wake_state_$id").apply()
    fun clearAll(ctx: Context) {
        val e = p(ctx).edit()
        p(ctx).all.keys.filter { it.startsWith("wake_state_") }.forEach { e.remove(it) }
        e.apply()
    }
    fun activeId(ctx: Context): String? = p(ctx).all.entries.firstOrNull { it.key.startsWith("wake_state_") && (it.value as? String)?.contains("\"active\":true") == true }?.key?.removePrefix("wake_state_")
}
