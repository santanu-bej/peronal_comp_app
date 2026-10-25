package com.teqsonic.goalcompass.alerts

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.teqsonic.goalcompass.store.EventQueue

/** Notification/banner actions handled natively and queued for Dart (todo_done / todo_snooze). */
class AlertActionReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        val id = intent.getStringExtra("id") ?: return
        val nid = intent.getIntExtra("nid", id.hashCode())
        ctx.getSystemService(NotificationManager::class.java).cancel(nid)
        when {
            intent.action?.endsWith("DONE") == true -> done(ctx, id)
            intent.action?.endsWith("SNOOZE") == true -> snooze(ctx, id)
        }
    }

    companion object {
        fun done(ctx: Context, id: String) {
            val todoId = id.removePrefix("todo:")
            EventQueue.add(ctx, "todo_done") { put("todoId", todoId) }
            ctx.getSystemService(NotificationManager::class.java).cancel(id.hashCode())
        }

        fun snooze(ctx: Context, id: String) {
            val until = System.currentTimeMillis() + 15 * 60_000L
            AlertScheduler.reschedule(ctx, id, until)
            EventQueue.add(ctx, "todo_snooze") { put("todoId", id.removePrefix("todo:")); put("until", until) }
            ctx.getSystemService(NotificationManager::class.java).cancel(id.hashCode())
        }
    }
}
