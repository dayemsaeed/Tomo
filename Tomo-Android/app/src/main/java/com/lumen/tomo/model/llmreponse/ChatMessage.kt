package com.lumen.tomo.model.llmreponse

import java.util.UUID

data class ChatMessage(
    val id: UUID = UUID.randomUUID(),
    val message: String,
    val isSender: Boolean
)