package com.teqsonic.goalcompass.guard

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.view.accessibility.AccessibilityNodeInfo
import com.teqsonic.goalcompass.store.EventQueue

/**
 * Records what is on screen in a few allow-listed apps (YouTube, Chrome, Brave, Instagram, Facebook),
 * only when it changes (debounced 3 s). Reads titles/channels/domains only: never text fields,
 * message content or notifications.
 */
class ContentCapture(private val ctx: Context) {
    private data class Item(val pkg: String, val title: String, val channel: String?, val kind: String, val start: Long)

    private var last: Item? = null
    private val handler = Handler(Looper.getMainLooper())
    private var pending: Runnable? = null

    fun onContentChanged(pkg: String, cfg: GuardConfig, rootProvider: () -> AccessibilityNodeInfo?) {
        if (pkg !in cfg.contentAllow) { flush(); return }
        pending?.let { handler.removeCallbacks(it) }
        val r = Runnable { capture(pkg, rootProvider()) }
        pending = r
        handler.postDelayed(r, 3000)
    }

    /** Close the current item (leaving the app / screen off). */
    fun flush() {
        pending?.let { handler.removeCallbacks(it) }
        val l = last ?: return
        last = null
        emit(l, System.currentTimeMillis())
    }

    private fun emit(i: Item, end: Long) {
        if (end - i.start < 3000) return
        EventQueue.add(ctx, "content") {
            put("pkg", i.pkg); put("title", i.title); put("kind", i.kind); put("start", i.start); put("end", end)
            if (i.channel != null) put("channel", i.channel)
        }
    }

    private fun capture(pkg: String, root: AccessibilityNodeInfo?) {
        root ?: return
        val now = System.currentTimeMillis()
        val item: Item? = when (pkg) {
            "com.google.android.youtube" -> youtube(root, now)
            "com.android.chrome", "com.brave.browser" -> browser(root, pkg, now)
            "com.instagram.android", "com.facebook.katana" -> social(root, pkg, now)
            else -> null
        }
        if (item == null) { return }
        val l = last
        if (l != null && l.pkg == item.pkg && l.title == item.title && l.channel == item.channel && l.kind == item.kind) return
        if (l != null) emit(l, now)
        last = item
    }

    private fun textOf(root: AccessibilityNodeInfo, id: String): String? {
        val nodes = root.findAccessibilityNodeInfosByViewId(id) ?: return null
        val n = nodes.firstOrNull { !it.isEditable && !it.text.isNullOrBlank() }
        val t = n?.text?.toString()
        nodes.forEach { it.recycleCompat() }
        return t
    }

    private fun youtube(root: AccessibilityNodeInfo, now: Long): Item? {
        val p = "com.google.android.youtube"
        val title = listOf("$p:id/title", "$p:id/watch_title", "$p:id/video_title").firstNotNullOfOrNull { textOf(root, it) } ?: return null
        val channel = listOf("$p:id/channel_name", "$p:id/byline", "$p:id/owner_name").firstNotNullOfOrNull { textOf(root, it) }
        return Item(p, title.take(140), channel?.take(80), "video", now)
    }

    private fun browser(root: AccessibilityNodeInfo, pkg: String, now: Long): Item? {
        val url = textOf(root, "$pkg:id/url_bar") ?: return null
        val domain = url.removePrefix("https://").removePrefix("http://").substringBefore('/').removePrefix("www.").take(80)
        if (domain.isBlank() || domain.contains(' ')) return null
        val title = root.window?.title?.toString()?.takeIf { it.isNotBlank() } ?: domain
        return Item(pkg, title.take(140), domain, "page", now)
    }

    private fun social(root: AccessibilityNodeInfo, pkg: String, now: Long): Item? {
        val reels = listOf("clips_viewer_view_pager", "clips_viewer_container", "reel_viewer_root", "root_clips_layout").any {
            root.findAccessibilityNodeInfosByViewId("$pkg:id/$it")?.isNotEmpty() == true
        }
        val dm = listOf("direct_thread", "row_thread_composer_edittext", "direct_inbox", "message_list").any {
            root.findAccessibilityNodeInfosByViewId("$pkg:id/$it")?.isNotEmpty() == true
        }
        val label = if (pkg == "com.instagram.android") "Instagram" else "Facebook"
        val kind = when { reels -> "reels"; dm -> "dm"; else -> "feed" }
        // kind only: never the content of messages
        return Item(pkg, "$label ${when (kind) { "reels" -> "Reels"; "dm" -> "Messages"; else -> "Feed" }}", null, kind, now)
    }
}
