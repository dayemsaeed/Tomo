package com.lumen.tomo.model.llmreponse

data class TaskRequest(
    val taskTitle: String,
    val taskDescription: String? = null
)
