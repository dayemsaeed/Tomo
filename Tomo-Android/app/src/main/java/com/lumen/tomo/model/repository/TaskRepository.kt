package com.lumen.tomo.model.repository

import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.model.dtos.TaskItemDTO
import com.lumen.tomo.model.llmreponse.BreakdownResponse
import com.lumen.tomo.model.llmreponse.TaskRequest
import retrofit2.Response
import java.time.LocalDateTime
import java.util.Date

interface TaskRepository {
    suspend fun insertTaskIntoRoomDb(task: TaskItem): Boolean
    suspend fun deleteTaskFromRoomDb(task: TaskItem): Boolean
    suspend fun getTasksFromRoomDb(date: String, userId: String): List<TaskItem>
    suspend fun updateTaskInRoomDb(task: TaskItem): Boolean
    suspend fun insertTaskIntoSupabaseDb(task: TaskItem): Result<Boolean>
    suspend fun deleteTaskFromSupabaseDb(task: TaskItem): Result<Boolean>
    suspend fun getTasksFromSupabaseDb(date: String, userId: String): Result<List<TaskItemDTO>>
    suspend fun getAllTasksFromSupabaseDb(): Result<List<TaskItemDTO>>
    suspend fun updateTaskCompletedInSupabaseDb(task: TaskItem): Result<Boolean>
    suspend fun breakDownTask(taskRequest: TaskRequest): Result<BreakdownResponse>
}