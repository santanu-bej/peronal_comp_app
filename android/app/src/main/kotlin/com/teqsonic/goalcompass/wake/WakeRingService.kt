package com.teqsonic.goalcompass.wake

import android.app.Notification
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.IBinder
import android.os.PowerManager
import android.os.VibrationEffect
import android.os.Vibrator
import android.util.Log
import androidx.core.app.NotificationCompat
import com.teqsonic.goalcompass.Notif
import com.teqsonic.goalcompass.R
import com.teqsonic.goalcompass.store.TAG

/** Plays the alarm on the alarm stream at full volume until proof is done (or snoozed). */
class WakeRingService : Service() {
    private var player: MediaPlayer? = null
    private var wl: PowerManager.WakeLock? = null

    override fun onBind(i: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val id = intent?.getStringExtra("id") ?: WakeState.activeId(this)
        if (intent?.action == ACTION_STOP || id == null) {
            stopAll()
            return START_NOT_STICKY
        }
        Notif.ensureChannels(this)
        val item = WakeScheduler.find(this, id)
        startForegroundCompat(buildNotification(id))
        wl = (getSystemService(POWER_SERVICE) as PowerManager).newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "goalcompass:wake").apply { acquire(30 * 60_000L) }
        if (item?.optString("proof") == "walk") StepProof.start(this)
        startSound(item?.optBoolean("vibrate", true) ?: true)
        // bring the proof UI up even if the full-screen intent is suppressed
        try { startActivity(Intent(this, WakeActivity::class.java).putExtra("id", id).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)) } catch (e: Exception) { Log.w(TAG, "wake activity start blocked: ${e.message}") }
        return START_STICKY
    }

    private fun buildNotification(id: String): Notification {
        val full = PendingIntent.getActivity(
            this, 1, Intent(this, WakeActivity::class.java).putExtra("id", id).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val maths = PendingIntent.getActivity(
            this, 2, Intent(this, MathsFallbackActivity::class.java).putExtra("id", id).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        return NotificationCompat.Builder(this, Notif.CH_WAKE)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Wake up")
            .setContentText("Prove you are awake to stop the alarm.")
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setOngoing(true)
            .setFullScreenIntent(full, true)
            .setContentIntent(full)
            .addAction(0, "Maths", maths)
            .build()
    }

    private fun startForegroundCompat(n: Notification) {
        if (Build.VERSION.SDK_INT >= 29) startForeground(NID, n, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK) else startForeground(NID, n)
    }

    private fun startSound(vibrate: Boolean) {
        stopSound()
        val am = getSystemService(AUDIO_SERVICE) as AudioManager
        am.setStreamVolume(AudioManager.STREAM_ALARM, am.getStreamMaxVolume(AudioManager.STREAM_ALARM), 0)
        val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM) ?: RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
        try {
            player = MediaPlayer().apply {
                setAudioAttributes(AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM).setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION).build())
                setDataSource(this@WakeRingService, uri)
                isLooping = true
                setVolume(1f, 1f)
                prepare()
                start()
            }
        } catch (e: Exception) {
            Log.e(TAG, "alarm sound failed: ${e.message}")
        }
        if (vibrate) {
            val v = getSystemService(Vibrator::class.java)
            v.vibrate(VibrationEffect.createWaveform(longArrayOf(0, 800, 500), 0), AudioAttributes.Builder().setUsage(AudioAttributes.USAGE_ALARM).build())
        }
    }

    private fun stopSound() {
        try { player?.stop(); player?.release() } catch (_: Exception) {}
        player = null
        getSystemService(Vibrator::class.java).cancel()
    }

    private fun stopAll() {
        stopSound()
        StepProof.stop(this)
        try { wl?.release() } catch (_: Exception) {}
        stopForeground(STOP_FOREGROUND_REMOVE)
        stopSelf()
    }

    override fun onDestroy() {
        stopSound()
        try { wl?.release() } catch (_: Exception) {}
        super.onDestroy()
    }

    companion object {
        const val NID = 9001
        const val ACTION_STOP = "com.teqsonic.goalcompass.WAKE_STOP"

        fun stop(ctx: Context) {
            ctx.startService(Intent(ctx, WakeRingService::class.java).setAction(ACTION_STOP))
        }
    }
}
