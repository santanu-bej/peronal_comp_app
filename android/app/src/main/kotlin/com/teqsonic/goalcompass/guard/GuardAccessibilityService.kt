package com.teqsonic.goalcompass.guard

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.content.IntentFilter
import android.content.BroadcastReceiver
import android.content.Context
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import com.teqsonic.goalcompass.store.EventQueue
import com.teqsonic.goalcompass.store.TAG

/**
 * Foreground-app detection, nudges, Shorts blocker, content capture and overlay banners.
 * No packageNames filter: it must see every foreground app. Per-event work is kept tiny.
 */
class GuardAccessibilityService : AccessibilityService() {
    private lateinit var overlay: Overlay
    private lateinit var nudges: NudgeEngine
    private lateinit var content: ContentCapture
    private val shorts = ShortsDetector()
    private var currentPkg: String? = null
    private var imePackages: Set<String> = emptySet()

    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(c: Context, i: Intent) {
            if (i.action == Intent.ACTION_SCREEN_OFF) { nudges.onScreenOff(); content.flush(); currentPkg = null }
        }
    }

    override fun onServiceConnected() {
        instance = this
        overlay = Overlay(this)
        nudges = NudgeEngine(this, this).also { it.start() }
        content = ContentCapture(this)
        imePackages = try {
            (getSystemService(Context.INPUT_METHOD_SERVICE) as android.view.inputmethod.InputMethodManager).inputMethodList.map { it.packageName }.toSet()
        } catch (e: Exception) { emptySet() }
        registerReceiver(screenReceiver, IntentFilter(Intent.ACTION_SCREEN_OFF))
        EventQueue.log(this, "guard", "Accessibility service connected")
        Log.i(TAG, "guard connected")
    }

    override fun onAccessibilityEvent(e: AccessibilityEvent) {
        val pkg = e.packageName?.toString() ?: return
        if (pkg == packageName || pkg == "com.android.systemui" || pkg in imePackages) return
        val cfg = GuardConfig.load(this)

        if (e.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            if (pkg != currentPkg) {
                content.flush()
                currentPkg = pkg
                nudges.onForeground(pkg)
            }
        }
        if (pkg != currentPkg) return

        if (shorts.isCandidate(pkg)) {
            val root = rootInActiveWindow
            if (shorts.check(root, pkg, cfg)) {
                performGlobalAction(GLOBAL_ACTION_BACK)
                overlay.toast("Shorts blocked. Back to your goal.")
                EventQueue.add(this, "nudge") { put("kind", "block"); put("pkg", pkg); put("text", "Shorts blocked"); put("action", "blocked") }
                return
            }
        }
        if (e.eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED || e.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            content.onContentChanged(pkg, cfg) { rootInActiveWindow }
        }
    }

    override fun onInterrupt() {}

    override fun onDestroy() {
        if (instance === this) instance = null
        try { unregisterReceiver(screenReceiver) } catch (_: Exception) {}
        nudges.stop()
        content.flush()
        overlay.hide()
        super.onDestroy()
    }

    fun showBanner(
        title: String, text: String, buttons: List<Pair<String, () -> Unit>>, autoHideMs: Long?,
        onAutoHide: (() -> Unit)? = null, escalated: Boolean = false,
    ) = overlay.show(title, text, buttons, autoHideMs, onAutoHide, escalated)

    fun hideBanner() = overlay.hide()
    fun testNudge() = nudges.test()

    companion object {
        @Volatile var instance: GuardAccessibilityService? = null
    }
}
