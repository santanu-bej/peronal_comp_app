package com.teqsonic.goalcompass.store

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.io.File

/**
 * Append-only JSON-lines file (max 5,000 lines). Kotlin writes while the app is closed; Dart drains
 * it on open or from the 15-minute WorkManager job.
 */
object EventQueue {
    private const val MAX_LINES = 5000
    private val lock = Any()
    @Volatile var liveListener: ((JSONObject) -> Unit)? = null

    private fun file(ctx: Context) = File(ctx.applicationContext.filesDir, "events.jsonl")

    fun add(ctx: Context, type: String, build: JSONObject.() -> Unit = {}) {
        val o = JSONObject().put("type", type).put("at", System.currentTimeMillis())
        o.build()
        synchronized(lock) {
            val f = file(ctx)
            f.appendText(o.toString() + "\n")
            if (f.length() > 2_000_000) {
                val lines = f.readLines()
                if (lines.size > MAX_LINES) f.writeText(lines.takeLast(MAX_LINES).joinToString("\n") + "\n")
            }
        }
        liveListener?.invoke(o)
    }

    fun log(ctx: Context, source: String, message: String, level: String = "info", extra: JSONObject.() -> Unit = {}) =
        add(ctx, source) {
            put("message", message)
            put("level", level)
            extra()
        }

    /** Returns every queued event as a JSON array string and clears the queue. */
    fun drain(ctx: Context): String = synchronized(lock) {
        val f = file(ctx)
        if (!f.exists()) return "[]"
        val arr = JSONArray()
        f.readLines().forEach { l -> if (l.isNotBlank()) try { arr.put(JSONObject(l)) } catch (_: Exception) {} }
        f.writeText("")
        arr.toString()
    }
}
