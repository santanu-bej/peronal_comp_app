package com.teqsonic.goalcompass.alerts

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.teqsonic.goalcompass.wake.WakeScheduler

/** Re-arms everything after reboot, app update, clock or timezone change. */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        AlertScheduler.rearm(ctx)
        WakeScheduler.rearm(ctx)
    }
}
