package com.lumen.tomo.model.llmreponse

data class ChatRequest(
    val messages: List<Map<String, String>>
)
