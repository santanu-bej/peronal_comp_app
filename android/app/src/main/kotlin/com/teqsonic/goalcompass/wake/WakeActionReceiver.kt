package com.teqsonic.goalcompass.wake

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/** Reserved for notification actions that act on the wake alarm without opening the UI. */
class WakeActionReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        val id = intent.getStringExtra("id") ?: return
        if (intent.action == "SNOOZE") WakeProof.snooze(ctx, id)
    }
}
