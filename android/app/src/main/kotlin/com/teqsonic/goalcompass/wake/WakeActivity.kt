package com.teqsonic.goalcompass.wake

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.WindowManager
import com.teqsonic.goalcompass.NativeBridgePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

/** Flutter proof UI (`/wake?id=…`) shown over the lock screen. */
class WakeActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setShowWhenLocked(true)
        setTurnScreenOn(true)
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
        (getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager).requestDismissKeyguard(this, null)
    }

    override fun getInitialRoute(): String = "/wake?id=${intent.getStringExtra("id") ?: WakeState.activeId(this) ?: ""}"

    override fun configureFlutterEngine(engine: FlutterEngine) {
        super.configureFlutterEngine(engine)
        NativeBridgePlugin.register(engine, applicationContext)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }
}
