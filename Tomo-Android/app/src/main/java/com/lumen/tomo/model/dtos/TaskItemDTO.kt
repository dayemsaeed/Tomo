package com.lumen.tomo.model.dtos

import kotlinx.serialization.Serializable
import kotlinx.serialization.SerialName
import java.util.UUID

@Serializable
data class TaskItemDTO(
    @SerialName("id")
    val id: String = UUID.randomUUID().toString(),

    @SerialName("task_title")
    val title: String,

    @SerialName("task_description")
    val description: String = "",

    @SerialName("task_created_at")
    val creationDate: String,

    @SerialName("task_completed")
    val completed: Boolean = false,

    @SerialName("task_tint")
    val color: Int,

    @SerialName("task_created_by")
    val createdBy: String
)

