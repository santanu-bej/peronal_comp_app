package com.teqsonic.goalcompass.wake

import android.content.Context
import com.teqsonic.goalcompass.store.EventQueue

/** Proof done / snooze logic shared by the bridge, the maths fallback and the notification. */
object WakeProof {
    fun done(ctx: Context, id: String) {
        val st = WakeState.get(ctx, id)
        val now = System.currentTimeMillis()
        val late = if (st.has("ringAt")) ((now - st.optLong("ringAt")) / 60_000L).toInt() else 0
        val escalated = st.optInt("escalations", 0) > 0
        WakeScheduler.cancelEscalation(ctx, id)
        WakeState.put(ctx, id, st.put("active", false))
        WakeRingService.stop(ctx)
        EventQueue.log(ctx, "wake", "Proof done") { put("routineId", id); put("lateMin", late); put("escalated", escalated); put("day", now) }
    }

    /** Returns snoozes left, or -1 if not allowed. Escalation is never moved. */
    fun snooze(ctx: Context, id: String): Int {
        val item = WakeScheduler.find(ctx, id) ?: return -1
        val st = WakeState.get(ctx, id)
        val max = item.optInt("snoozeMax", 1)
        val used = st.optInt("snoozes", 0)
        if (used >= max) return -1
        st.put("snoozes", used + 1)
        WakeState.put(ctx, id, st)
        WakeRingService.stop(ctx)
        WakeScheduler.scheduleSnooze(ctx, id, System.currentTimeMillis() + 5 * 60_000L)
        EventQueue.log(ctx, "wake", "Snoozed") { put("routineId", id); put("left", max - used - 1) }
        return max - used - 1
    }

    fun state(ctx: Context, id: String): Map<String, Any> {
        val item = WakeScheduler.find(ctx, id)
        val st = WakeState.get(ctx, id)
        val left = (item?.optInt("snoozeMax", 1) ?: 0) - st.optInt("snoozes", 0)
        return mapOf("snoozesLeft" to left.coerceAtLeast(0), "active" to st.optBoolean("active"))
    }
}
