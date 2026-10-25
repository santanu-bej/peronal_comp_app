package com.teqsonic.goalcompass

import android.Manifest
import android.app.AppOpsManager
import android.app.NotificationManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.teqsonic.goalcompass.alerts.AlertScheduler
import com.teqsonic.goalcompass.alerts.FocusNotification
import com.teqsonic.goalcompass.escalate.EscalationReceiver
import com.teqsonic.goalcompass.guard.GuardAccessibilityService
import com.teqsonic.goalcompass.store.EventQueue
import com.teqsonic.goalcompass.store.NativeStore
import com.teqsonic.goalcompass.usage.UsageReader
import com.teqsonic.goalcompass.wake.StepProof
import com.teqsonic.goalcompass.wake.WakeProof
import com.teqsonic.goalcompass.wake.WakeScheduler
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/** MethodChannel `goalcompass/native` + EventChannel `goalcompass/events`. Dart decides, Kotlin executes. */
class NativeBridgePlugin(private val ctx: Context, engine: FlutterEngine) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    private val channel = MethodChannel(engine.dartExecutor.binaryMessenger, "goalcompass/native")
    private val events = EventChannel(engine.dartExecutor.binaryMessenger, "goalcompass/events")
    private val main = Handler(Looper.getMainLooper())

    init {
        channel.setMethodCallHandler(this)
        events.setStreamHandler(this)
    }

    fun navigate(route: String) = main.post { channel.invokeMethod("navigate", route) }

    override fun onListen(args: Any?, sink: EventChannel.EventSink) {
        // Live events (foreground app, nudge actions, wake state) while the app is open.
        EventQueue.liveListener = { o -> main.post { sink.success(o.toString()) } }
    }

    override fun onCancel(args: Any?) { EventQueue.liveListener = null }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        try {
            when (call.method) {
                "status" -> result.success(status())
                "open" -> { open(call.argument<String>("setting") ?: ""); result.success(null) }
                "syncAlerts" -> { AlertScheduler.sync(ctx, call.arguments as String); result.success(null) }
                "syncWake" -> { WakeScheduler.sync(ctx, call.arguments as String); result.success(null) }
                "setGuardConfig" -> { NativeStore.putJson(ctx, "guard", call.arguments as String); result.success(null) }
                "setTopTasks" -> { NativeStore.putJson(ctx, "top_tasks", call.arguments as String); result.success(null) }
                "setSecrets" -> { setSecrets(call); result.success(null) }
                "readUsage" -> result.success(UsageReader.read(ctx, (call.argument<Number>("from"))!!.toLong(), (call.argument<Number>("to"))!!.toLong()))
                "drainEvents" -> result.success(EventQueue.drain(ctx))
                "wakeProofDone" -> { WakeProof.done(ctx, call.argument<String>("id") ?: ""); result.success(null) }
                "wakeSnooze" -> result.success(WakeProof.snooze(ctx, call.argument<String>("id") ?: ""))
                "wakeSteps" -> result.success(StepProof.steps())
                "wakeState" -> result.success(WakeProof.state(ctx, wakeId(call)))
                "testEscalation" -> {
                    EscalationReceiver.enqueue(ctx, call.argument<String>("id") ?: "", 0, true, "esc-test")
                    result.success(null)
                }
                "testAlert" -> { AlertScheduler.scheduleTest(ctx, call.argument<Int>("seconds") ?: 10); result.success(null) }
                "testNudge" -> {
                    val svc = GuardAccessibilityService.instance
                    if (svc != null) svc.testNudge() else EventQueue.log(ctx, "guard", "Test nudge: accessibility service is not running", "warn")
                    result.success(null)
                }
                "focusNotification" -> {
                    if (call.argument<Boolean>("on") == true) FocusNotification.show(ctx, call.argument<String>("title") ?: "Focus session running") else FocusNotification.hide(ctx)
                    result.success(null)
                }
                "initialRoute" -> result.success(null)
                "stepCounter" -> result.success(stepCounterToday())
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("native", e.message, null)
        }
    }

    private fun wakeId(call: MethodCall): String =
        call.argument<String>("id") ?: com.teqsonic.goalcompass.wake.WakeState.activeId(ctx) ?: ""

    private fun setSecrets(call: MethodCall) {
        val e = NativeStore.secure(ctx).edit()
        call.argument<String>("whatsappToken")?.let { e.putString("wa_token", it) } ?: e.remove("wa_token")
        call.argument<String>("phoneNumberId")?.let { e.putString("wa_phone_id", it) }
        call.argument<String>("template")?.let { e.putString("wa_template", it) }
        call.argument<String>("lang")?.let { e.putString("wa_lang", it) }
        call.argument<String>("graphVersion")?.let { e.putString("wa_graph", it) }
        e.apply()
    }

    private fun status(): Map<String, Any> {
        val am = ctx.getSystemService(AppOpsManager::class.java)
        @Suppress("DEPRECATION")
        val usage = am.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), ctx.packageName) == AppOpsManager.MODE_ALLOWED
        val enabledSvcs = Settings.Secure.getString(ctx.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES) ?: ""
        val comp = ComponentName(ctx, GuardAccessibilityService::class.java).flattenToString()
        val fsi = if (Build.VERSION.SDK_INT >= 34) ctx.getSystemService(NotificationManager::class.java).canUseFullScreenIntent() else true
        return mapOf(
            "accessibility" to (enabledSvcs.split(':').any { it.equals(comp, true) || it.endsWith("GuardAccessibilityService") && it.startsWith(ctx.packageName) }),
            "usageAccess" to usage,
            "notifications" to NotificationManagerCompat.from(ctx).areNotificationsEnabled(),
            "exactAlarm" to AlertScheduler.canExact(ctx),
            "fullScreenIntent" to fsi,
            "battery" to ctx.getSystemService(PowerManager::class.java).isIgnoringBatteryOptimizations(ctx.packageName),
            "sms" to (ctx.checkSelfPermission(Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED),
            "activityRecognition" to (ctx.checkSelfPermission(Manifest.permission.ACTIVITY_RECOGNITION) == PackageManager.PERMISSION_GRANTED),
            "brand" to Build.MANUFACTURER.lowercase(),
            "sdk" to Build.VERSION.SDK_INT,
        )
    }

    private fun open(setting: String) {
        val pkg = Uri.parse("package:${ctx.packageName}")
        val i = when (setting) {
            "accessibility" -> Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
            "usage_access" -> Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
            "app_info" -> Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, pkg)
            "battery" -> Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS, pkg)
            "exact_alarm" -> if (Build.VERSION.SDK_INT >= 31) Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM, pkg) else Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, pkg)
            "full_screen_intent" -> if (Build.VERSION.SDK_INT >= 34) Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT, pkg) else Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, pkg)
            "notifications" -> Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).putExtra(Settings.EXTRA_APP_PACKAGE, ctx.packageName)
            else -> return
        }
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        try { ctx.startActivity(i) } catch (e: Exception) {
            ctx.startActivity(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS, pkg).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        }
    }

    /** Fallback steps for today from TYPE_STEP_COUNTER (cumulative since boot) minus a per-day baseline. */
    private fun stepCounterToday(): Int {
        if (ctx.checkSelfPermission(Manifest.permission.ACTIVITY_RECOGNITION) != PackageManager.PERMISSION_GRANTED) return 0
        val sm = ctx.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val s = sm.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) ?: return 0
        val latch = CountDownLatch(1)
        var value = -1f
        val l = object : SensorEventListener {
            override fun onSensorChanged(e: SensorEvent) { value = e.values[0]; latch.countDown() }
            override fun onAccuracyChanged(s: Sensor?, a: Int) {}
        }
        sm.registerListener(l, s, SensorManager.SENSOR_DELAY_NORMAL)
        latch.await(1500, TimeUnit.MILLISECONDS)
        sm.unregisterListener(l)
        if (value < 0) return 0
        val p = NativeStore.prefs(ctx)
        val day = java.time.LocalDate.now(java.time.ZoneId.of("Asia/Kolkata")).toString()
        var base = p.getFloat("step_base", -1f)
        if (p.getString("step_day", "") != day || base < 0 || value < base) {
            base = value
            p.edit().putString("step_day", day).putFloat("step_base", base).apply()
        }
        return (value - base).toInt()
    }

    companion object {
        fun register(engine: FlutterEngine, ctx: Context) = NativeBridgePlugin(ctx, engine)
    }
}
