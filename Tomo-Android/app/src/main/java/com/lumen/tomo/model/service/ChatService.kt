package com.lumen.tomo.model.service

import com.lumen.tomo.BuildConfig
import com.lumen.tomo.model.GPTResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface ChatService {
    @Headers(
        "Authorization: ${BuildConfig.SUPABASE_KEY}",
        "Content-Type: application/json"
    )
    @POST(BuildConfig.BOT_URI)
    suspend fun generateText(@Body messages: Map<String, Any>): Response<GPTResponse>
}