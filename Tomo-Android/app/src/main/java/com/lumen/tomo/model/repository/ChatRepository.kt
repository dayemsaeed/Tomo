package com.lumen.tomo.model.repository

import com.lumen.tomo.model.ChatRequest
import com.lumen.tomo.model.GPTResponse


interface ChatRepository {
    suspend fun fetchGeneratedText(chatRequest: ChatRequest): Result<GPTResponse>
}