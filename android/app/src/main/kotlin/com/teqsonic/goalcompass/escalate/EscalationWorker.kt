package com.teqsonic.goalcompass.escalate

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import androidx.core.app.NotificationCompat
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
import androidx.work.WorkerParameters
import com.teqsonic.goalcompass.Notif
import com.teqsonic.goalcompass.R
import com.teqsonic.goalcompass.guard.GuardConfig
import com.teqsonic.goalcompass.guard.TopTasks
import com.teqsonic.goalcompass.store.EventQueue
import com.teqsonic.goalcompass.store.forEachObject
import com.teqsonic.goalcompass.wake.WakeScheduler
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * For each contact: WhatsApp template if the channel includes WhatsApp and the network is up,
 * otherwise (or on failure) the same text as SMS from the SIM. Every result is logged in EventQueue.
 */
class EscalationWorker(private val ctx: Context, params: WorkerParameters) : CoroutineWorker(ctx, params) {
    override suspend fun getForegroundInfo(): ForegroundInfo {
        Notif.ensureChannels(ctx)
        val n = NotificationCompat.Builder(ctx, Notif.CH_ESC)
            .setSmallIcon(R.mipmap.ic_launcher).setContentTitle("Contacting your wake-up contacts").setOngoing(true).build()
        return ForegroundInfo(9002, n)
    }

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        val id = inputData.getString("id") ?: return@withContext Result.success()
        val late = inputData.getInt("late", 0)
        val test = inputData.getBoolean("test", false)
        val item = WakeScheduler.find(ctx, id)
        if (item == null) {
            EventQueue.log(ctx, "escalation", "No wake routine $id to escalate", "error")
            return@withContext Result.success()
        }
        val cfg = GuardConfig.load(ctx)
        val topTask = TopTasks.top(ctx)?.title ?: "your first task"
        val template = item.optString("message")
        val channel = item.optString("channel", "both")
        val contacts = item.optJSONArray("contacts")
        if (contacts == null || contacts.length() == 0) {
            EventQueue.log(ctx, "escalation", "No contacts configured", "error")
            return@withContext Result.success()
        }
        var sent = 0
        contacts.forEachObject { c ->
            if (test && sent >= 1) return@forEachObject
            val name = c.optString("name")
            val phone = c.optString("phone")
            val text = template
                .replace("{contact}", name).replace("{user}", cfg.user)
                .replace("{minutes}", late.toString()).replace("{top_task}", topTask)
            var done = false
            val wantsWa = channel == "whatsapp" || channel == "both"
            val wantsSms = channel == "sms" || channel == "both"
            if (wantsWa) {
                if (online()) {
                    val r = WhatsAppSender.send(ctx, phone, name, cfg.user, late, topTask)
                    EventQueue.log(ctx, "escalation", if (r.first) "WhatsApp sent to $name" else "WhatsApp failed for $name: ${r.second}", if (r.first) "info" else "error") {
                        put("channel", "whatsapp"); put("ok", r.first); put("test", test)
                    }
                    done = r.first
                } else {
                    EventQueue.log(ctx, "escalation", "No internet for WhatsApp ($name)", "warn")
                }
            }
            if (!done && (wantsSms || channel == "both" || wantsWa)) {
                if (wantsSms || wantsWa) {
                    val r = SmsSender.send(ctx, phone, text, name)
                    EventQueue.log(ctx, "escalation", if (r.first) "SMS queued to $name" else "SMS failed for $name: ${r.second}", if (r.first) "info" else "error") {
                        put("channel", "sms"); put("ok", r.first); put("test", test)
                    }
                    done = r.first
                }
            }
            if (done) sent++
        }
        Result.success()
    }

    private fun online(): Boolean {
        val cm = ctx.getSystemService(ConnectivityManager::class.java)
        val caps = cm.getNetworkCapabilities(cm.activeNetwork) ?: return false
        return caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) && caps.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED)
    }
}
