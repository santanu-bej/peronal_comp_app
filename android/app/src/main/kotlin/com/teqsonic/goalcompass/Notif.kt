package com.teqsonic.goalcompass

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri

/** Notification channels + the intent that opens the app on a goalcompass:// route. */
object Notif {
    const val CH_ALERTS = "alerts"
    const val CH_SILENT = "alerts_silent"
    const val CH_WAKE = "wake"
    const val CH_FOCUS = "focus"
    const val CH_ESC = "escalation"

    fun ensureChannels(ctx: Context) {
        val nm = ctx.getSystemService(NotificationManager::class.java)
        nm.createNotificationChannel(NotificationChannel(CH_ALERTS, "Reminders", NotificationManager.IMPORTANCE_HIGH).apply { description = "Todo reminders, daily focus, stage due" })
        nm.createNotificationChannel(NotificationChannel(CH_SILENT, "Silent reminders", NotificationManager.IMPORTANCE_LOW).apply { description = "Reminders during quiet hours or Do not disturb" })
        nm.createNotificationChannel(NotificationChannel(CH_WAKE, "Wake alarm", NotificationManager.IMPORTANCE_HIGH).apply { setSound(null, null); enableVibration(false) })
        nm.createNotificationChannel(NotificationChannel(CH_FOCUS, "Focus session", NotificationManager.IMPORTANCE_LOW))
        nm.createNotificationChannel(NotificationChannel(CH_ESC, "Escalation", NotificationManager.IMPORTANCE_DEFAULT))
    }

    fun openApp(ctx: Context, route: String?, requestCode: Int): PendingIntent {
        val i = Intent(ctx, MainActivity::class.java).apply {
            action = Intent.ACTION_VIEW
            data = Uri.parse("goalcompass://${(route ?: "home").removePrefix("goalcompass://").removePrefix("/")}")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        return PendingIntent.getActivity(ctx, requestCode, i, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }
}
