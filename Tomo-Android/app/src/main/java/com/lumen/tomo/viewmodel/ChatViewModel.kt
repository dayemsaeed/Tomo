package com.lumen.tomo.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lumen.tomo.model.dtos.toChatMessage
import com.lumen.tomo.model.llmreponse.ChatMessage
import com.lumen.tomo.model.llmreponse.ChatRequest
import com.lumen.tomo.model.llmreponse.toDTO
import com.lumen.tomo.model.repository.ChatRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.gotrue.auth
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import java.time.LocalDateTime
import java.time.ZoneId
import java.util.UUID
import javax.inject.Inject

@HiltViewModel
class ChatViewModel @Inject constructor(
    private val repository: ChatRepository,
    supabaseClient: SupabaseClient
) : ViewModel() {
    private val _messages = MutableStateFlow<List<ChatMessage>>(emptyList())
    val messages = _messages.asStateFlow()

    private val conversationId = supabaseClient.auth.currentUserOrNull()?.id ?: UUID.randomUUID().toString() // For single conversation scenario

    // Method to send a message
    fun sendMessage(messageText: String) {
        val trimmedText = messageText.trim().takeIf { it.isNotEmpty() } ?: return

        // Create a new ChatMessage instance for the sent message
        val newMessage = ChatMessage(
            conversationId = conversationId,
            content = trimmedText,
            isSender = true,
            createdAt = LocalDateTime.now(ZoneId.systemDefault()).toString()
        )
        _messages.value += newMessage

        viewModelScope.launch(Dispatchers.IO) {
            // Store the sent message in the database
            repository.storeMessage(newMessage.toDTO())

            // Create a system message to set the context for the GPT model
            val systemMessage = mapOf(
                "role" to "system",
                "content" to "Today's date: ${LocalDateTime.now(ZoneId.systemDefault())}. You are a funny, helpful friend who is caring, empathetic, and gentle. You speak like a person using a conversational tone and give no indication that you are a bot..."
            )

            // Create the user message for the GPT model
            val userMessage = mapOf(
                "role" to "user",
                "content" to trimmedText
            )

            // Prepare the chat request with the message history
            val messageHistory = listOf(systemMessage, userMessage).toMutableList()
            for (message in _messages.value) {
                val messageMap = mapOf(
                    "role" to if (message.isSender) "user" else "assistant",
                    "content" to message.content
                )
                messageHistory.add(messageMap)
            }
            val chatRequest = ChatRequest(messages = messageHistory)

            try {
                // Fetch the response from the GPT model
                val response = repository.fetchGeneratedText(chatRequest).getOrThrow()
                response.choices.firstOrNull()?.message?.content?.let { responseText ->
                    // Create a new ChatMessage instance for the received message
                    val responseMessage = ChatMessage(
                        conversationId = conversationId,
                        content = responseText,
                        isSender = false,
                        createdAt = LocalDateTime.now(ZoneId.systemDefault()).toString()
                    )
                    _messages.value += responseMessage
                    // Store the received message in the database
                    repository.storeMessage(responseMessage.toDTO())
                }
            } catch (e: Exception) {
                // Handle errors and display an error message
                val errorMessage = ChatMessage(
                    conversationId = conversationId,
                    content = "An error occurred: ${e.message}",
                    isSender = false,
                    createdAt = LocalDateTime.now(ZoneId.systemDefault()).toString()
                )
                _messages.value += errorMessage
                repository.storeMessage(errorMessage.toDTO())
            }
        }
    }

    // Method to load messages from the database
    fun loadMessages() {
        viewModelScope.launch(Dispatchers.IO) {
            // Retrieve messages from the repository
            val messageDTOs = repository.getMessages(conversationId)
            _messages.value = messageDTOs.getOrDefault(emptyList()).sortedBy { it.createdAt }.map { it.toChatMessage() }
        }
    }
}
