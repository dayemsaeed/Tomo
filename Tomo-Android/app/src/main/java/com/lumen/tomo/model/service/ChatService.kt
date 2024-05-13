package com.lumen.tomo.model.service

import com.lumen.tomo.BuildConfig
import com.lumen.tomo.model.ChatRequest
import com.lumen.tomo.model.GPTResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface ChatService {
    @POST(BuildConfig.BOT_URI)
    suspend fun generateText(@Body chatRequest: ChatRequest): Response<GPTResponse>
}