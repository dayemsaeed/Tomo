package com.lumen.tomo.model.repository

import com.lumen.tomo.model.dtos.ChatMessageDTO
import com.lumen.tomo.model.llmreponse.ChatMessage
import com.lumen.tomo.model.llmreponse.ChatRequest
import com.lumen.tomo.model.llmreponse.GPTResponse
import java.util.UUID


interface ChatRepository {
    suspend fun fetchGeneratedText(chatRequest: ChatRequest): Result<GPTResponse>
    suspend fun storeMessage(chatMessageDTO: ChatMessageDTO): Result<Boolean>
    suspend fun getMessages(conversationId: String): Result<List<ChatMessageDTO>>
}