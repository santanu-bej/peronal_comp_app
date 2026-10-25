package com.teqsonic.goalcompass

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine

/** FlutterFragmentActivity: required by the Health Connect permission flow. */
class MainActivity : FlutterFragmentActivity() {
    private var bridge: NativeBridgePlugin? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Notif.ensureChannels(this)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        bridge = NativeBridgePlugin.register(flutterEngine, applicationContext)
    }

    /** goalcompass://todos → /todos (cold start). */
    override fun getInitialRoute(): String? = routeOf(intent)

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        routeOf(intent)?.let { bridge?.navigate(it) }
    }

    private fun routeOf(i: Intent?): String? {
        val d = i?.data ?: return null
        if (d.scheme != "goalcompass") return null
        val host = d.host ?: return null
        val path = d.path ?: ""
        return "/$host$path"
    }
}
