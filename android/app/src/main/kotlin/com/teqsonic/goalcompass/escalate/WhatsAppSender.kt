package com.teqsonic.goalcompass.escalate

import android.content.Context
import com.teqsonic.goalcompass.store.NativeStore
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.TimeUnit

/** WhatsApp Cloud API template message. Secrets come from EncryptedSharedPreferences. */
object WhatsAppSender {
    private val client = OkHttpClient.Builder()
        .connectTimeout(20, TimeUnit.SECONDS).readTimeout(20, TimeUnit.SECONDS).writeTimeout(20, TimeUnit.SECONDS).build()

    fun send(ctx: Context, phone: String, contact: String, user: String, lateMin: Int, topTask: String): Pair<Boolean, String> {
        val s = NativeStore.secure(ctx)
        val token = s.getString("wa_token", null)
        val phoneId = s.getString("wa_phone_id", null)
        if (token.isNullOrBlank() || phoneId.isNullOrBlank()) return false to "WhatsApp token or phone number ID missing"
        val template = s.getString("wa_template", "wake_alert") ?: "wake_alert"
        val lang = s.getString("wa_lang", "en") ?: "en"
        val graph = s.getString("wa_graph", "v21.0") ?: "v21.0"
        fun p(t: String) = JSONObject().put("type", "text").put("text", t)
        val body = JSONObject()
            .put("messaging_product", "whatsapp")
            .put("to", phone.removePrefix("+"))
            .put("type", "template")
            .put("template", JSONObject()
                .put("name", template)
                .put("language", JSONObject().put("code", lang))
                .put("components", JSONArray().put(JSONObject().put("type", "body").put("parameters", JSONArray()
                    .put(p(contact)).put(p(user)).put(p(lateMin.toString())).put(p(topTask))))))
        val req = Request.Builder()
            .url("https://graph.facebook.com/$graph/$phoneId/messages")
            .header("Authorization", "Bearer $token")
            .post(body.toString().toRequestBody("application/json".toMediaType()))
            .build()
        return try {
            client.newCall(req).execute().use { r ->
                if (r.isSuccessful) true to "ok" else false to "HTTP ${r.code}: ${(r.body?.string() ?: "").take(160)}"
            }
        } catch (e: Exception) {
            false to (e.message ?: "network error")
        }
    }
}
