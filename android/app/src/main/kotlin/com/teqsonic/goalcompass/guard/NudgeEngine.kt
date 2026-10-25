package com.teqsonic.goalcompass.guard

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import com.teqsonic.goalcompass.store.EventQueue
import java.util.Random

/**
 * Wasting-time nudges. Mirrors lib/core/logic/nudge_rules.dart `decideNudge`:
 * entertainment/social app for ≥ N minutes inside focus hours, a todo scoring ≥ minScore open,
 * not in quiet hours / DND / deny-list, ≤ 1 nudge per 10 min, "5 more min" max 2, 3rd nudge escalated.
 */
class NudgeEngine(private val ctx: Context, private val svc: GuardAccessibilityService) {
    private class Session(val pkg: String, var start: Long) {
        var lastSeen = start
        var nudgesShown = 0
        var snoozes = 0
        var snoozedUntil = 0L
        var lastNudge = 0L
    }

    private val sessions = HashMap<String, Session>()
    private var current: Session? = null
    private var lastTemplate = -1
    private val handler = Handler(Looper.getMainLooper())
    private val rng = Random()

    private val tick = object : Runnable {
        override fun run() {
            evaluate()
            handler.postDelayed(this, 30_000)
        }
    }

    fun start() { handler.removeCallbacks(tick); handler.postDelayed(tick, 30_000) }
    fun stop() { handler.removeCallbacks(tick) }

    fun onForeground(pkg: String) {
        val now = System.currentTimeMillis()
        current?.lastSeen = now
        val existing = sessions[pkg]
        // returning to the same app within a minute continues the session
        val s = if (existing != null && now - existing.lastSeen <= 60_000) existing else Session(pkg, now).also { sessions[pkg] = it }
        s.lastSeen = now
        current = s
        evaluate()
    }

    fun onScreenOff() { current = null }

    fun evaluate() {
        val s = current ?: return
        val now = System.currentTimeMillis()
        s.lastSeen = now
        val cfg = GuardConfig.load(ctx)
        if (!cfg.nudgesEnabled || cfg.dnd) return
        if (s.pkg in cfg.denyList || s.pkg == ctx.packageName) return
        val cat = cfg.categoryOf(s.pkg)
        if (cat != "entertainment" && cat != "social") return
        if (cfg.inQuietHours() || !cfg.inFocusHours()) return
        val top = TopTasks.top(ctx) ?: return
        if (top.score < cfg.minScore) return
        val minutes = ((now - s.start) / 60_000).toInt()
        if (minutes < cfg.afterMin) return
        if (now < s.snoozedUntil) return
        if (s.lastNudge != 0L && s.snoozes == 0 && now - s.lastNudge < cfg.minGapMin * 60_000L) return
        if (s.lastNudge != 0L && s.snoozes > 0 && now - s.lastNudge < cfg.minGapMin * 60_000L && now < s.snoozedUntil) return
        show(s, cfg, top, minutes, escalated = s.nudgesShown >= 2)
    }

    private fun appLabel(pkg: String): String = try {
        ctx.packageManager.getApplicationLabel(ctx.packageManager.getApplicationInfo(pkg, 0)).toString()
    } catch (e: Exception) { pkg.substringAfterLast('.').replaceFirstChar { it.uppercase() } }

    private fun render(cfg: GuardConfig, escalated: Boolean, vars: Map<String, String>): String {
        val list = if (escalated) cfg.escalatedTemplates else cfg.normalTemplates
        var i = rng.nextInt(list.size)
        if (list.size > 1 && i == lastTemplate) i = (i + 1) % list.size
        lastTemplate = i
        var t = list[i]
        vars.forEach { (k, v) -> t = t.replace("{$k}", v) }
        return t
    }

    private fun show(s: Session, cfg: GuardConfig, top: TopTask, minutes: Int, escalated: Boolean, test: Boolean = false) {
        val text = render(cfg, escalated, mapOf(
            "app" to appLabel(s.pkg), "min" to minutes.toString(), "task" to top.title, "score" to top.score.toString(),
            "goal" to cfg.goalTitle, "pct" to cfg.goalPct.toString(), "days" to cfg.goalDays.toString(), "user" to cfg.user,
        ))
        s.nudgesShown++
        s.lastNudge = System.currentTimeMillis()
        val kind = if (escalated) "escalated" else "nudge"
        fun log(action: String) = EventQueue.add(ctx, "nudge") { put("kind", kind); put("pkg", s.pkg); put("todoId", top.id); put("text", text); put("action", action) }
        val buttons = mutableListOf<Pair<String, () -> Unit>>()
        buttons += "Start now" to {
            log("opened"); svc.hideBanner()
            ctx.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse("goalcompass://todos")).setPackage(ctx.packageName).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
        }
        if (!escalated && s.snoozes < cfg.snoozeMax) {
            buttons += "5 more min" to {
                s.snoozes++; s.snoozedUntil = System.currentTimeMillis() + 5 * 60_000L
                log("snoozed"); svc.hideBanner()
            }
        } else if (escalated) {
            buttons += "Dismiss" to { log("dismissed"); svc.hideBanner() }
        }
        svc.showBanner(
            if (escalated) "Back to work" else "Time check",
            text, buttons,
            autoHideMs = if (escalated) null else 30_000,
            onAutoHide = { log("ignored") },
            escalated = escalated,
        )
        if (!test) EventQueue.log(ctx, "guard", "Nudge shown ($kind) for ${s.pkg} after $minutes min")
    }

    /** "Test nudge" from Focus guard: fake session on whichever app is foreground. */
    fun test() {
        val cfg = GuardConfig.load(ctx)
        val top = TopTasks.top(ctx) ?: TopTask("", "Send invoice to Astroremedys", 95)
        val s = Session("com.instagram.android", System.currentTimeMillis() - 20 * 60_000L)
        show(s, cfg, top, 20, escalated = false, test = true)
    }
}
