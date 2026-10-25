package com.teqsonic.goalcompass.wake

import android.app.Activity
import android.os.Bundle
import android.text.InputType
import android.view.Gravity
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import java.util.Random

/** Pure-native proof if the Flutter UI cannot start: 3 two-digit sums. */
class MathsFallbackActivity : Activity() {
    private val r = Random()
    private val sums = List(3) { (10 + r.nextInt(89)) to (10 + r.nextInt(89)) }
    private val fields = mutableListOf<EditText>()

    override fun onCreate(b: Bundle?) {
        super.onCreate(b)
        setShowWhenLocked(true)
        setTurnScreenOn(true)
        val id = intent.getStringExtra("id") ?: WakeState.activeId(this) ?: ""
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(48, 48, 48, 48)
            setBackgroundColor(0xFFFF8A8A.toInt())
        }
        root.addView(TextView(this).apply { text = "Solve 3 sums to stop the alarm"; textSize = 20f; setTextColor(0xFFFFFFFF.toInt()); gravity = Gravity.CENTER })
        sums.forEach { (a, c) ->
            root.addView(TextView(this).apply { text = "$a + $c ="; textSize = 22f; setTextColor(0xFFFFFFFF.toInt()); setPadding(0, 24, 0, 0) })
            val e = EditText(this).apply { inputType = InputType.TYPE_CLASS_NUMBER; setTextColor(0xFFFFFFFF.toInt()) }
            fields += e
            root.addView(e, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT))
        }
        root.addView(Button(this).apply {
            text = "Stop alarm"
            setOnClickListener {
                val ok = sums.indices.all { fields[it].text.toString().trim().toIntOrNull() == sums[it].first + sums[it].second }
                if (ok) { WakeProof.done(this@MathsFallbackActivity, id); finish() } else fields.forEach { it.error = null }
            }
        })
        setContentView(root)
    }
}
