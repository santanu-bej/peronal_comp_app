package com.teqsonic.goalcompass.store

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import org.json.JSONArray
import org.json.JSONObject

const val TAG = "GoalCompass"

/** Plain prefs hold plans (alerts, wake routines, guard config). Secrets go to EncryptedSharedPreferences. */
object NativeStore {
    private const val PLAIN = "gc_native"
    private const val SECURE = "gc_secure"

    fun prefs(ctx: Context): SharedPreferences = ctx.applicationContext.getSharedPreferences(PLAIN, Context.MODE_PRIVATE)

    fun secure(ctx: Context): SharedPreferences {
        val app = ctx.applicationContext
        return try {
            val key = MasterKey.Builder(app).setKeyScheme(MasterKey.KeyScheme.AES256_GCM).build()
            EncryptedSharedPreferences.create(
                app, SECURE, key,
                EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
                EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM,
            )
        } catch (e: Exception) {
            Log.e(TAG, "secure prefs unavailable: ${e.message}")
            app.getSharedPreferences("gc_secure_fallback_empty", Context.MODE_PRIVATE)
        }
    }

    fun array(ctx: Context, key: String): JSONArray = try {
        JSONArray(prefs(ctx).getString(key, "[]"))
    } catch (e: Exception) {
        JSONArray()
    }

    fun obj(ctx: Context, key: String): JSONObject = try {
        JSONObject(prefs(ctx).getString(key, "{}"))
    } catch (e: Exception) {
        JSONObject()
    }

    fun putJson(ctx: Context, key: String, json: String) {
        prefs(ctx).edit().putString(key, json).apply()
    }

    fun nowMs() = System.currentTimeMillis()
}

/** Run an action for each element of a JSONArray of objects. */
inline fun JSONArray.forEachObject(f: (JSONObject) -> Unit) {
    for (i in 0 until length()) optJSONObject(i)?.let(f)
}
