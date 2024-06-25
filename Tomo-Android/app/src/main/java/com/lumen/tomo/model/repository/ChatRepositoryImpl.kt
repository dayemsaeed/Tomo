package com.lumen.tomo.model.repository

import android.util.Log
import com.lumen.tomo.model.llmreponse.ChatRequest
import com.lumen.tomo.model.llmreponse.GPTResponse
import com.lumen.tomo.model.service.ChatService
import javax.inject.Inject

class ChatRepositoryImpl @Inject constructor(
    private val chatService: ChatService
): ChatRepository {
    override suspend fun fetchGeneratedText(chatRequest: ChatRequest): Result<GPTResponse> {
        return try {
            val response = chatService.generateText(chatRequest)
            if (response.isSuccessful && response.body() != null) {
                Result.success(response.body()!!)
            } else {
                Log.e("ChatRepository", "Error response code: ${response.code()}, message: ${response.message()}, body: ${response.errorBody()?.string()}")
                Result.failure(Exception("Failed to fetch data: ${response.message()}"))
            }
        } catch (e: Exception) {
            Log.e("ChatRepository", "Network error: ${e.message}", e)
            Result.failure(Exception("Network error: ${e.message}", e))
        }
    }
}