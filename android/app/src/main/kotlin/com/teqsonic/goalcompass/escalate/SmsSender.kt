package com.teqsonic.goalcompass.escalate

import android.Manifest
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.SmsManager
import com.teqsonic.goalcompass.store.EventQueue

object SmsSender {
    fun send(ctx: Context, phone: String, text: String, name: String): Pair<Boolean, String> {
        if (ctx.checkSelfPermission(Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) return false to "SMS permission not granted"
        return try {
            val sms = if (Build.VERSION.SDK_INT >= 31) ctx.getSystemService(SmsManager::class.java) else @Suppress("DEPRECATION") SmsManager.getDefault()
            val parts = sms.divideMessage(text)
            val sentIntents = ArrayList<PendingIntent>()
            for (i in parts.indices) {
                val it = Intent(ctx, SmsSentReceiver::class.java).putExtra("name", name).putExtra("part", i)
                sentIntents.add(PendingIntent.getBroadcast(ctx, (name + i + System.currentTimeMillis()).hashCode(), it, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE))
            }
            sms.sendMultipartTextMessage(phone, null, parts, sentIntents, null)
            true to "queued"
        } catch (e: Exception) {
            false to (e.message ?: "sms error")
        }
    }
}

/** Sent-status of each SMS part (resultCode RESULT_OK = handed to the network). */
class SmsSentReceiver : BroadcastReceiver() {
    override fun onReceive(ctx: Context, intent: Intent) {
        val ok = resultCode == android.app.Activity.RESULT_OK
        EventQueue.log(ctx, "escalation", if (ok) "SMS delivered to network for ${intent.getStringExtra("name")}" else "SMS send error $resultCode for ${intent.getStringExtra("name")}", if (ok) "info" else "error") {
            put("channel", "sms"); put("sent", ok)
        }
    }
}
