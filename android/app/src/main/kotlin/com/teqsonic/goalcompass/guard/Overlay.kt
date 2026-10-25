package com.teqsonic.goalcompass.guard

import android.accessibilityservice.AccessibilityService
import android.content.Context
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Handler
import android.os.Looper
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView

/**
 * Clay-look banners drawn with TYPE_ACCESSIBILITY_OVERLAY (no SYSTEM_ALERT_WINDOW needed):
 * surface fill, 24dp radius, 1dp primary-tint border, 8dp elevation, Fredoka-like bold title.
 */
class Overlay(private val svc: AccessibilityService) {
    private val wm = svc.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    private val handler = Handler(Looper.getMainLooper())
    private var view: View? = null
    private var hideRunnable: Runnable? = null

    private val dark get() = (svc.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES
    private val bold: Typeface by lazy {
        try { Typeface.createFromAsset(svc.assets, "flutter_assets/assets/fonts/Fredoka.ttf") } catch (e: Exception) { Typeface.create("sans-serif-medium", Typeface.BOLD) }
    }
    private val body: Typeface by lazy {
        try { Typeface.createFromAsset(svc.assets, "flutter_assets/assets/fonts/Nunito.ttf") } catch (e: Exception) { Typeface.DEFAULT }
    }

    private fun dp(v: Int) = (v * svc.resources.displayMetrics.density).toInt()

    fun show(
        title: String, text: String, buttons: List<Pair<String, () -> Unit>>, autoHideMs: Long?,
        onAutoHide: (() -> Unit)? = null, escalated: Boolean = false,
    ) {
        hide()
        val surface = if (dark) Color.parseColor("#262338") else Color.parseColor("#F8F5FE")
        val ink = if (dark) Color.parseColor("#ECE9F8") else Color.parseColor("#2D2943")
        val primary = if (dark) Color.parseColor("#9A8CFF") else Color.parseColor("#7B6CF6")
        val rose = Color.parseColor("#FF8A8A")

        val card = LinearLayout(svc).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(18), dp(16), dp(18), dp(14))
            background = GradientDrawable().apply {
                setColor(surface)
                cornerRadius = dp(24).toFloat()
                setStroke(dp(1), (primary and 0x00FFFFFF) or 0x66000000)
            }
            elevation = dp(8).toFloat()
        }
        card.addView(TextView(svc).apply {
            this.text = title
            typeface = bold
            textSize = 17f
            setTextColor(if (escalated) rose else ink)
        })
        card.addView(TextView(svc).apply {
            this.text = text
            typeface = body
            textSize = 15f
            setTextColor(ink)
            setPadding(0, dp(6), 0, dp(10))
        })
        val row = LinearLayout(svc).apply { orientation = LinearLayout.HORIZONTAL; gravity = Gravity.END }
        buttons.forEachIndexed { idx, (label, action) ->
            val primaryBtn = idx == 0
            row.addView(Button(svc).apply {
                this.text = label
                isAllCaps = false
                typeface = bold
                textSize = 14f
                setTextColor(if (primaryBtn) Color.WHITE else ink)
                background = GradientDrawable().apply {
                    setColor(if (primaryBtn) primary else (if (dark) Color.parseColor("#1F1D30") else Color.parseColor("#E6E0F5")))
                    cornerRadius = dp(18).toFloat()
                }
                setPadding(dp(14), 0, dp(14), 0)
                minHeight = dp(40)
                minimumHeight = dp(40)
                setOnClickListener { cancelAutoHide(); action() }
            }, LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, dp(40)).apply { leftMargin = dp(8) })
        }
        card.addView(row)

        val lp = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_ACCESSIBILITY_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS,
            PixelFormat.TRANSLUCENT,
        ).apply {
            gravity = Gravity.TOP
            x = 0
            y = statusBarHeight() + dp(8)
        }
        val holder = LinearLayout(svc).apply { setPadding(dp(12), 0, dp(12), 0); addView(card) }
        try {
            wm.addView(holder, lp)
            view = holder
        } catch (e: Exception) {
            view = null
            return
        }
        if (autoHideMs != null) {
            hideRunnable = Runnable { hide(); onAutoHide?.invoke() }.also { handler.postDelayed(it, autoHideMs) }
        }
    }

    /** Small toast-like banner (Shorts blocked). */
    fun toast(text: String) = show("Goal Compass", text, emptyList(), autoHideMs = 2500)

    private fun cancelAutoHide() { hideRunnable?.let { handler.removeCallbacks(it) }; hideRunnable = null }

    fun hide() {
        cancelAutoHide()
        view?.let { try { wm.removeView(it) } catch (_: Exception) {} }
        view = null
    }

    private fun statusBarHeight(): Int {
        val id = svc.resources.getIdentifier("status_bar_height", "dimen", "android")
        return if (id > 0) svc.resources.getDimensionPixelSize(id) else dp(24)
    }
}
