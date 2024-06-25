package com.lumen.tomo.model.repository

import com.lumen.tomo.model.llmreponse.ChatRequest
import com.lumen.tomo.model.llmreponse.GPTResponse


interface ChatRepository {
    suspend fun fetchGeneratedText(chatRequest: ChatRequest): Result<GPTResponse>
}