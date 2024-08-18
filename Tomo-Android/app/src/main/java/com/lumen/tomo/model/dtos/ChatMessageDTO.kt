package com.lumen.tomo.model.dtos

import com.lumen.tomo.model.llmreponse.ChatMessage
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ChatMessageDTO(
    @SerialName("id")
    val id: String,

    @SerialName("conversation_id")
    val conversationId: String,

    @SerialName("is_sender")
    val isSender: Boolean,

    @SerialName("content")
    val content: String,

    @SerialName("created_at")
    val createdAt: String
)

fun ChatMessageDTO.toChatMessage(): ChatMessage {
    return ChatMessage(
        id = this.id,
        conversationId = this.conversationId,
        content = this.content,
        isSender = this.isSender,
        createdAt = this.createdAt
    )
}
