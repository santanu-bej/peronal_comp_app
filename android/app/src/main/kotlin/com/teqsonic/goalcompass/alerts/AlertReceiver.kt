package com.teqsonic.goalcompass.alerts

import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.core.app.NotificationCompat
import com.teqsonic.goalcompass.Notif
import com.teqsonic.goalcompass.R
import com.teqsonic.goalcompass.guard.GuardAccessibilityService
import com.teqsonic.goalcompass.guard.GuardConfig
import com.teqsonic.goalcompass.store.EventQueue
import org.json.JSONObject

class AlertReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        val id = intent.getStringExtra("id") ?: return
        val alert = AlertScheduler.find(ctx, id) ?: return
        AlertScheduler.markFired(ctx, id)
        show(ctx, alert, missed = false)
    }

    companion object {
        fun show(ctx: Context, a: JSONObject, missed: Boolean) {
            Notif.ensureChannels(ctx)
            val id = a.optString("id")
            val kind = a.optString("kind", "reminder")
            val cfg = GuardConfig.load(ctx)
            val silent = cfg.dnd || cfg.inQuietHours()
            val title = (if (missed) "Missed: " else "") + a.optString("title")
            val body = a.optString("body")
            val nid = id.hashCode()

            val b = NotificationCompat.Builder(ctx, if (silent) Notif.CH_SILENT else Notif.CH_ALERTS)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentTitle(title)
                .setContentText(body)
                .setStyle(NotificationCompat.BigTextStyle().bigText(body))
                .setAutoCancel(true)
                .setCategory(NotificationCompat.CATEGORY_REMINDER)
                .setPriority(if (silent) NotificationCompat.PRIORITY_LOW else NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(Notif.openApp(ctx, a.optString("deepLink", "goalcompass://home"), nid))
            if (id.startsWith("todo:")) {
                b.addAction(0, "Done", action(ctx, "done", id, nid))
                b.addAction(0, "Snooze 15m", action(ctx, "snooze", id, nid))
            }
            if (kind == "daily") b.addAction(0, "Add todo", Notif.openApp(ctx, "add", nid + 7))
            try {
                ctx.getSystemService(NotificationManager::class.java).notify(nid, b.build())
            } catch (_: SecurityException) {
            }

            if (!silent) {
                val svc = GuardAccessibilityService.instance
                if (svc != null) {
                    val buttons = mutableListOf<Pair<String, () -> Unit>>()
                    buttons += "Open" to { openApp(ctx, a.optString("deepLink", "goalcompass://home")); svc.hideBanner() }
                    if (id.startsWith("todo:")) {
                        buttons += "Snooze 15m" to { AlertActionReceiver.snooze(ctx, id); svc.hideBanner() }
                        buttons += "Done" to { AlertActionReceiver.done(ctx, id); svc.hideBanner() }
                    }
                    svc.showBanner(title, body, buttons, autoHideMs = 90_000)
                }
            }
            EventQueue.log(ctx, "alert", "Alert shown: $title", if (silent) "warn" else "info") { put("id", id); put("silent", silent); put("missed", missed) }
        }

        private fun openApp(ctx: Context, link: String) {
            val i = Intent(Intent.ACTION_VIEW, Uri.parse(link)).apply {
                setPackage(ctx.packageName)
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            ctx.startActivity(i)
        }

        private fun action(ctx: Context, what: String, id: String, nid: Int): PendingIntent {
            val i = Intent(ctx, AlertActionReceiver::class.java).apply {
                action = "com.teqsonic.goalcompass.ALERT_${what.uppercase()}"
                data = Uri.parse("goalcompass://alert-action/$what/${Uri.encode(id)}")
                putExtra("id", id)
                putExtra("nid", nid)
            }
            return PendingIntent.getBroadcast(ctx, nid + (if (what == "done") 1 else 2), i, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        }
    }
}
