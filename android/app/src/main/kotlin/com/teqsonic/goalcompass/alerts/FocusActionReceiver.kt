package com.teqsonic.goalcompass.alerts

import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.teqsonic.goalcompass.store.EventQueue
import com.teqsonic.goalcompass.store.NativeStore

object FocusNotification {
    const val ID = 4242

    fun isActive(ctx: Context) = NativeStore.prefs(ctx).getBoolean("focus_active", false)

    fun show(ctx: Context, title: String) {
        com.teqsonic.goalcompass.Notif.ensureChannels(ctx)
        NativeStore.prefs(ctx).edit().putBoolean("focus_active", true).apply()
        val stop = android.app.PendingIntent.getBroadcast(
            ctx, 11, Intent(ctx, FocusActionReceiver::class.java).setAction("STOP"),
            android.app.PendingIntent.FLAG_UPDATE_CURRENT or android.app.PendingIntent.FLAG_IMMUTABLE,
        )
        val n = androidx.core.app.NotificationCompat.Builder(ctx, com.teqsonic.goalcompass.Notif.CH_FOCUS)
            .setSmallIcon(com.teqsonic.goalcompass.R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText("Tap Stop when you finish.")
            .setOngoing(true)
            .setUsesChronometer(true)
            .setContentIntent(com.teqsonic.goalcompass.Notif.openApp(ctx, "time", 12))
            .addAction(0, "Stop", stop)
            .addAction(0, "Add todo", com.teqsonic.goalcompass.Notif.openApp(ctx, "add", 13))
            .build()
        try { ctx.getSystemService(NotificationManager::class.java).notify(ID, n) } catch (_: SecurityException) {}
    }

    fun hide(ctx: Context) {
        NativeStore.prefs(ctx).edit().putBoolean("focus_active", false).apply()
        ctx.getSystemService(NotificationManager::class.java).cancel(ID)
    }
}

class FocusActionReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        FocusNotification.hide(ctx)
        EventQueue.add(ctx, "focus_stop")
    }
}
