package com.teqsonic.goalcompass.wake

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import java.util.concurrent.atomic.AtomicInteger

/** Counts steps with TYPE_STEP_DETECTOR (needs ACTIVITY_RECOGNITION) for the Walk proof. */
object StepProof {
    private val count = AtomicInteger(0)
    private var listener: SensorEventListener? = null

    fun steps(): Int = count.get()

    fun start(ctx: Context) {
        stop(ctx)
        count.set(0)
        val sm = ctx.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        val s = sm.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR) ?: return
        val l = object : SensorEventListener {
            override fun onSensorChanged(e: SensorEvent) { count.addAndGet(e.values.size.coerceAtLeast(1)) }
            override fun onAccuracyChanged(s: Sensor?, a: Int) {}
        }
        try { sm.registerListener(l, s, SensorManager.SENSOR_DELAY_FASTEST) ; listener = l } catch (_: SecurityException) {}
    }

    fun stop(ctx: Context) {
        val l = listener ?: return
        (ctx.getSystemService(Context.SENSOR_SERVICE) as SensorManager).unregisterListener(l)
        listener = null
    }
}
