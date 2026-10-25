package com.teqsonic.goalcompass.guard

import android.content.Context
import com.teqsonic.goalcompass.store.NativeStore
import org.json.JSONObject
import java.time.ZoneId
import java.time.ZonedDateTime

/** Parsed view of the JSON pushed by Dart `setGuardConfig`. Missing keys fall back to PRD defaults. */
class GuardConfig(private val j: JSONObject) {
    val nudgesEnabled get() = j.optBoolean("nudgesEnabled", true)
    val dnd get() = j.optBoolean("dnd", false)
    val afterMin get() = j.optInt("afterMin", 15)
    val minScore get() = j.optInt("minScore", 70)
    val snoozeMax get() = j.optInt("snoozeMax", 2)
    val minGapMin get() = j.optInt("minGapMin", 10)
    val quietStart get() = j.optInt("quietStartMin", 23 * 60)
    val quietEnd get() = j.optInt("quietEndMin", 7 * 60)
    val user: String get() = j.optString("user", "Santanu")
    val goalTitle: String get() = j.optString("goalTitle", "your goal")
    val goalPct get() = j.optInt("goalPct", 0)
    val goalDays get() = j.optInt("goalDays", 0)
    val blockYoutube get() = j.optBoolean("blockYoutube", true)
    val blockInstagram get() = j.optBoolean("blockInstagram", true)
    val blockBrowsers get() = j.optBoolean("blockBrowsers", true)

    private fun strings(k: String, def: List<String> = emptyList()): List<String> {
        val a = j.optJSONArray(k) ?: return def
        return (0 until a.length()).map { a.optString(it) }
    }

    val denyList: Set<String> get() = strings("denyList").toSet()
    val youtubeIds get() = strings("youtubeIds")
    val instagramIds get() = strings("instagramIds")
    val browserBars get() = strings("browserBars")
    val contentAllow: Set<String> get() = strings("contentAllow").toSet()
    val normalTemplates get() = strings("normalTemplates", listOf("{min} min on {app}. Urgent: {task} ({score}). Start now?"))
    val escalatedTemplates get() = strings("escalatedTemplates", listOf("Third reminder. You've spent {min} min on {app}. Close it and do {task} now."))

    fun categoryOf(pkg: String): String = j.optJSONObject("categories")?.optString(pkg, "other") ?: "other"

    private fun now(): ZonedDateTime = ZonedDateTime.now(ZoneId.of("Asia/Kolkata"))
    private fun minuteOfDay(): Int = now().let { it.hour * 60 + it.minute }

    fun inQuietHours(): Boolean {
        val m = minuteOfDay()
        if (quietStart == quietEnd) return false
        return if (quietStart < quietEnd) m in quietStart until quietEnd else (m >= quietStart || m < quietEnd)
    }

    fun inFocusHours(): Boolean {
        val m = minuteOfDay()
        val wd = now().dayOfWeek.value // 1 = Mon
        val a = j.optJSONArray("focusWindows") ?: return false
        for (i in 0 until a.length()) {
            val w = a.optJSONObject(i) ?: continue
            val days = w.optJSONArray("days") ?: continue
            val has = (0 until days.length()).any { days.optInt(it) == wd }
            if (has && m >= w.optInt("start") && m < w.optInt("end")) return true
        }
        return false
    }

    companion object {
        fun load(ctx: Context) = GuardConfig(NativeStore.obj(ctx, "guard"))
    }
}

/** Top-5 open todos snapshot (setTopTasks). */
data class TopTask(val id: String, val title: String, val score: Int)

object TopTasks {
    fun load(ctx: Context): List<TopTask> {
        val a = NativeStore.array(ctx, "top_tasks")
        return (0 until a.length()).mapNotNull { a.optJSONObject(it) }.map { TopTask(it.optString("id"), it.optString("title"), it.optInt("score")) }
    }

    fun top(ctx: Context): TopTask? = load(ctx).firstOrNull()
}
