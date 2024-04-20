package com.lumen.tomo.model.service

import com.lumen.tomo.model.GPTResponse
import com.lumen.tomo.utils.BOT_URI
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface ChatService {
    @Headers(
        "Authorization: Bearer <your_token_here>",
        "Content-Type: application/json"
    )
    @POST(BOT_URI)
    suspend fun generateText(@Body messages: Map<String, Any>): Response<GPTResponse>
}