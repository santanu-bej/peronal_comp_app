package com.teqsonic.goalcompass.wake

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat
import com.teqsonic.goalcompass.store.EventQueue
import org.json.JSONObject

/** Alarm fired (ring or snooze re-ring). Starts the foreground ring service and arms escalation. */
class WakeReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        val id = intent.getStringExtra("id") ?: return
        val snooze = intent.getBooleanExtra("snooze", false)
        val item = WakeScheduler.find(ctx, id) ?: return
        val now = System.currentTimeMillis()

        var st = WakeState.get(ctx, id)
        if (!snooze || !st.optBoolean("active")) {
            // fresh ring
            st = JSONObject().put("active", true).put("ringAt", now).put("snoozes", 0).put("escalations", 0)
            WakeState.put(ctx, id, st)
            val grace = item.optInt("graceMin", 10) * 60_000L
            WakeScheduler.scheduleEscalation(ctx, id, now + grace)
            EventQueue.log(ctx, "wake", "Rang") { put("routineId", id) }
            // next day's alarm
            WakeScheduler.armNext(ctx, item)
        } else {
            EventQueue.log(ctx, "wake", "Rang again after snooze") { put("routineId", id) }
        }
        ContextCompat.startForegroundService(ctx, Intent(ctx, WakeRingService::class.java).putExtra("id", id))
    }
}
