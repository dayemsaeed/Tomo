package com.lumen.tomo.model.service

import com.lumen.tomo.BuildConfig
import com.lumen.tomo.model.llmreponse.ChatRequest
import com.lumen.tomo.model.llmreponse.GPTResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface ChatService {
    @POST(BuildConfig.BOT_URI)
    suspend fun generateText(@Body chatRequest: ChatRequest): Response<GPTResponse>
}