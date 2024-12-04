package com.lumen.tomo.model.llmreponse

import com.lumen.tomo.model.dtos.ChatMessageDTO
import kotlinx.serialization.Serializable
import java.util.UUID

@Serializable
data class ChatMessage(
    val id: String = UUID.randomUUID().toString(),
    val conversationId: String,
    val content: String,
    val isSender: Boolean,
    val createdAt: String
)

// Extension function to convert ChatMessage to ChatMessageDTO
fun ChatMessage.toDTO(): ChatMessageDTO {
    return ChatMessageDTO(
        id = this.id,
        conversationId = this.conversationId,
        isSender = this.isSender,
        content = this.content,
        createdAt = this.createdAt
    )
}