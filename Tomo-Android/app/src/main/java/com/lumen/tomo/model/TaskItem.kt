package com.lumen.tomo.model

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.lumen.tomo.model.dtos.TaskItemDTO
import kotlinx.serialization.Serializable
import java.util.UUID

@Entity
@Serializable
data class TaskItem(
    @PrimaryKey
    val id: String = UUID.randomUUID().toString(),

    @ColumnInfo(name = "task_title")
    val title: String,

    @ColumnInfo(name = "task_description")
    val description: String = "",

    @ColumnInfo(name = "task_created_at")
    val creationDate: String,

    @ColumnInfo(name = "task_completed")
    val completed: Boolean = false,

    @ColumnInfo(name = "task_tint")
    val color: Int,

    @ColumnInfo(name = "task_created_by", defaultValue = "-1")
    val createdBy: String
)

// Extension function to convert TaskItem to TaskItemDTO
fun TaskItem.toDTO(): TaskItemDTO {
    return TaskItemDTO(
        id = this.id,
        title = this.title,
        description = this.description,
        creationDate = this.creationDate,
        completed = this.completed,
        color = this.color,
        createdBy = this.createdBy
    )
}
