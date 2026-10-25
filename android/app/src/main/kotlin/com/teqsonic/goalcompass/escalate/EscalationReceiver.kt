package com.teqsonic.goalcompass.escalate

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.PowerManager
import androidx.work.Data
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import com.teqsonic.goalcompass.store.EventQueue
import com.teqsonic.goalcompass.wake.WakeScheduler
import com.teqsonic.goalcompass.wake.WakeState

/**
 * Grace time elapsed without proof. Runs natively with the app killed: wake lock + expedited worker.
 * Escalates once, then once more after another grace period, then stops escalating.
 */
class EscalationReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        val id = intent.getStringExtra("id") ?: return
        val st = WakeState.get(ctx, id)
        if (!st.optBoolean("active")) return // proof already done
        val item = WakeScheduler.find(ctx, id) ?: return
        val now = System.currentTimeMillis()
        val stage = st.optInt("escalations", 0) + 1
        val lateMin = ((now - st.optLong("ringAt", now)) / 60_000L).toInt()

        (ctx.getSystemService(Context.POWER_SERVICE) as PowerManager)
            .newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "goalcompass:escalation").apply { acquire(60_000L) }

        st.put("escalations", stage)
        WakeState.put(ctx, id, st)
        if (stage < 2) WakeScheduler.scheduleEscalation(ctx, id, now + item.optInt("graceMin", 10) * 60_000L)
        EventQueue.log(ctx, "escalation", "Escalation $stage started ($lateMin min late)") { put("routineId", id) }

        enqueue(ctx, id, lateMin, test = false, tag = "esc-$id-$stage")
    }

    companion object {
        fun enqueue(ctx: Context, id: String, lateMin: Int, test: Boolean, tag: String) {
            val req = OneTimeWorkRequestBuilder<EscalationWorker>()
                .setInputData(Data.Builder().putString("id", id).putInt("late", lateMin).putBoolean("test", test).build())
                .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                .build()
            WorkManager.getInstance(ctx).enqueueUniqueWork(tag + "-" + System.currentTimeMillis(), ExistingWorkPolicy.REPLACE, req)
        }
    }
}
