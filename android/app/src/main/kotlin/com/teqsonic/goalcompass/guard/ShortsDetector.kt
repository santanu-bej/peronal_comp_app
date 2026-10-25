package com.teqsonic.goalcompass.guard

import android.view.accessibility.AccessibilityNodeInfo

/**
 * Detects YouTube Shorts / Instagram Reels by view ids (editable in config) and shorts/reel URLs in
 * browser address bars. Throttled to 300 ms; 1.2 s cool-down after a block.
 */
class ShortsDetector {
    private var lastCheck = 0L
    private var lastBlock = 0L

    private val browsers = setOf("com.android.chrome", "com.brave.browser", "com.sec.android.app.sbrowser", "org.mozilla.firefox", "com.microsoft.emmx", "com.opera.browser")

    fun isCandidate(pkg: String) = pkg == "com.google.android.youtube" || pkg == "com.instagram.android" || pkg in browsers

    /** @return true if the screen is a blocked short-video surface. */
    fun check(root: AccessibilityNodeInfo?, pkg: String, cfg: GuardConfig): Boolean {
        val now = System.currentTimeMillis()
        if (root == null || now - lastCheck < 300 || now - lastBlock < 1200) return false
        lastCheck = now
        val hit = when {
            pkg == "com.google.android.youtube" && cfg.blockYoutube -> anyId(root, pkg, cfg.youtubeIds)
            pkg == "com.instagram.android" && cfg.blockInstagram -> anyId(root, pkg, cfg.instagramIds)
            pkg in browsers && cfg.blockBrowsers -> urlBlocked(root, pkg, cfg.browserBars)
            else -> false
        }
        if (hit) lastBlock = now
        return hit
    }

    private fun anyId(root: AccessibilityNodeInfo, pkg: String, ids: List<String>): Boolean {
        for (id in ids) {
            val full = if (id.contains(":")) id else "$pkg:id/$id"
            val nodes = root.findAccessibilityNodeInfosByViewId(full) ?: continue
            val visible = nodes.any { it.isVisibleToUser }
            nodes.forEach { it.recycleCompat() }
            if (visible) return true
        }
        return false
    }

    private fun urlBlocked(root: AccessibilityNodeInfo, pkg: String, bars: List<String>): Boolean {
        for (bar in bars.filter { it.startsWith("$pkg:") }) {
            val nodes = root.findAccessibilityNodeInfosByViewId(bar) ?: continue
            val txt = nodes.firstOrNull()?.text?.toString()?.lowercase() ?: ""
            nodes.forEach { it.recycleCompat() }
            if (txt.contains("youtube.com/shorts") || txt.contains("instagram.com/reel")) return true
        }
        return false
    }
}

@Suppress("DEPRECATION")
fun AccessibilityNodeInfo.recycleCompat() {
    try { recycle() } catch (_: Exception) {}
}
