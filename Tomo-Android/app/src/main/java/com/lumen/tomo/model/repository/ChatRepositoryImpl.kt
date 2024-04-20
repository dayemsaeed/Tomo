package com.lumen.tomo.model.repository

import com.lumen.tomo.model.GPTResponse
import com.lumen.tomo.model.service.ChatService
import javax.inject.Inject

class ChatRepositoryImpl @Inject constructor(
    private val chatService: ChatService
): ChatRepository {
    override suspend fun fetchGeneratedText(messages: List<Map<String, String>>): Result<GPTResponse> {
        return try {
            val response = chatService.generateText(mapOf("messages" to messages))
            if (response.isSuccessful && response.body() != null) {
                Result.success(response.body()!!)
            } else {
                Result.failure(Exception("Failed to fetch data: ${response.message()}"))
            }
        } catch (e: Exception) {
            Result.failure(Exception("Network error: ${e.message}", e))
        }
    }
}