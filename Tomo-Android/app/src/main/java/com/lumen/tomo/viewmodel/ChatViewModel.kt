package com.lumen.tomo.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lumen.tomo.model.ChatMessage
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

        val messageHistory = listOf(mapOf("role" to "user", "content" to trimmedText))

        viewModelScope.launch(Dispatchers.IO) {
            try {
                val response = repository.fetchGeneratedText(messageHistory).getOrThrow()
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
}
