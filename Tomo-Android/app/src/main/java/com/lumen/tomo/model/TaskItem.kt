package com.lumen.tomo.model

import androidx.compose.ui.graphics.Color
import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import java.time.LocalDateTime
import java.util.UUID

@Entity
data class TaskItem(
    @PrimaryKey val id: UUID = UUID.randomUUID(),
    @ColumnInfo(name = "task_title") var title: String,
    @ColumnInfo(name = "task_created_at") val creationDate: LocalDateTime,
    @ColumnInfo(name = "task_completed") var completed: Boolean = false,
    @ColumnInfo(name = "task_tint") var color: Int,
    @ColumnInfo(name = "task_description") var description: String = "",
    @ColumnInfo(name = "task_created_by", defaultValue = "-1") val createdBy: UUID
)