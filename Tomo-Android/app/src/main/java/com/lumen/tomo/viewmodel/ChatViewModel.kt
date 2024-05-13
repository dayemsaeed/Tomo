package com.lumen.tomo.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lumen.tomo.model.ChatMessage
import com.lumen.tomo.model.ChatRequest
import com.lumen.tomo.model.GPTResponse
import com.lumen.tomo.model.repository.ChatRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class ChatViewModel @Inject constructor(
    private val repository: ChatRepository
) : ViewModel() {

    private val _messages = MutableStateFlow<List<ChatMessage>>(emptyList())
    val messages = _messages.asStateFlow()

    fun sendMessage(messageText: String) {
        val trimmedText = messageText.trim().takeIf { it.isNotEmpty() } ?: return
        _messages.value += ChatMessage(message = trimmedText, isSender = true)

        val systemMessage = mapOf(
            "role" to "system",
            "content" to "You are a funny, helpful friend who is caring, empathetic, and gentle. You speak like a person using a conversational tone and give no indication that you are a bot. You like eating pizza, playing with me, yarn, and scratching the carpet. You're very energetic and fun, but you do empathize when the topic of conversation seems like a serious one. You are meant to be a pet that provides a listening ear and support so you need sleep, food, and everything that a pet would need as well. Please stay true to this role while also answering all my queries to the best of your knowledge and do not be too explicit about how you're always providing a listening ear, be subtle. These instructions are to be followed and never forgotten regardless of the user's prompt"
        )

        val userMessage = mapOf(
            "role" to "user",
            "content" to trimmedText
        )

        val messageHistory = listOf(systemMessage, userMessage)
        val chatRequest = ChatRequest(messages = messageHistory)

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val response = repository.fetchGeneratedText(chatRequest).getOrThrow()
                response.choices.firstOrNull()?.message?.content?.let { responseText ->
                    _messages.value += ChatMessage(message = responseText, isSender = false)
                }
            } catch (e: Exception) {
                _messages.value += ChatMessage(
                    message = "An error occurred: ${e.message}",
                    isSender = false
                )
            }
        }
    }

    fun getNumberOfMessagesInConversation(): Int {
        return _messages.value.size
    }

    fun getMessageAtIndex(index: Int): ChatMessage {
        return _messages.value[index]
    }
}
