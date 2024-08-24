package com.lumen.tomo.model.repository

import android.util.Log
import com.lumen.tomo.model.dtos.ChatMessageDTO
import com.lumen.tomo.model.llmreponse.ChatMessage
import com.lumen.tomo.model.llmreponse.ChatRequest
import com.lumen.tomo.model.llmreponse.GPTResponse
import com.lumen.tomo.model.llmreponse.toDTO
import com.lumen.tomo.model.service.ChatService
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.from
import io.github.jan.supabase.postgrest.query.Order
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.util.UUID
import javax.inject.Inject

class ChatRepositoryImpl @Inject constructor(
    private val supabaseClient: SupabaseClient,
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

    override suspend fun storeMessage(chatMessageDTO: ChatMessageDTO): Result<Boolean> {
        return try {
            withContext(Dispatchers.IO) {
                val response = supabaseClient.from("messages").insert(chatMessageDTO)
                if (response.data.isNotEmpty()) {
                    Result.success(true)
                }
                else {
                    Result.failure(Exception("Could not store message"))
                }
            }
        } catch (e: Exception) {
            Log.e("ChatRepository", "Error storing message: ${e.message}", e)
            Result.failure(e)
        }
    }

    override suspend fun getMessages(conversationId: String): Result<List<ChatMessageDTO>> {
        val response = supabaseClient.from("messages")
            .select {
                filter {
                    eq("conversation_id", conversationId)
                }
                order("created_at",Order.DESCENDING)
                limit(20)
            }

        if (response.data.isNotEmpty()) {
            val messages = response.decodeList<ChatMessageDTO>()
            return Result.success(messages)
        }
        else {
            return Result.failure(Exception("No messages found"))
        }
    }
}