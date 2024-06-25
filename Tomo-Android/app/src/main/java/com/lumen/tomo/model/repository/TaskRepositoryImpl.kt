package com.lumen.tomo.model.repository

import android.util.Log
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.model.daos.TaskDao
import com.lumen.tomo.model.llmreponse.BreakdownResponse
import com.lumen.tomo.model.llmreponse.TaskRequest
import com.lumen.tomo.model.service.TaskService
import io.github.jan.supabase.SupabaseClient
import retrofit2.Response
import java.time.LocalDateTime
import java.util.Date
import java.util.logging.Logger
import javax.inject.Inject

class TaskRepositoryImpl @Inject constructor(
    private val taskService: TaskService,
    private val taskDao: TaskDao
): TaskRepository {
    override suspend fun insertTaskIntoRoomDb(task: TaskItem): Boolean {
        try {
            taskDao.insertTask(task)
        }
        catch (e: Exception) {
            Log.e("TASKREPOSITORY", "Local insert failed. Message: ${e.message}")
            return false
        }
        return true
    }

    override suspend fun deleteTaskFromRoomDb(task: TaskItem): Boolean {
        try {
            taskDao.deleteTask(task)
        }
        catch (e: Exception) {
            Log.e("TASKREPOSITORY", "Local delete failed. Message: ${e.message}")
            return false
        }
        return true
    }

    override suspend fun getTasksFromRoomDb(date: LocalDateTime): List<TaskItem> {
        var taskList: List<TaskItem> = emptyList()
        try {
            val dateString = date.toLocalDate().toString()  // Convert LocalDateTime to date string (yyyy-MM-dd)
            taskList = taskDao.getTasksCreatedOnDate(dateString)
        }
        catch (e: Exception) {
            Log.e("TASKREPOSITORY", "Local fetch failed. Message: ${e.message}")
        }
        return taskList
    }

    override suspend fun updateTaskInRoomDb(task: TaskItem): Boolean {
        try {
            taskDao.updateTask(task)
        } catch (e: Exception) {
            Log.e("TASKREPOSITORY", "Local update failed. Message: ${e.message}")
            return false
        }
        return true
    }

    override suspend fun insertTaskIntoSupabaseDb(task: TaskItem): Result<Boolean> {
        TODO("Not yet implemented")
    }

    override suspend fun deleteTaskFromSupabaseDb(task: TaskItem): Result<Boolean> {
        TODO("Not yet implemented")
    }

    override suspend fun getTasksFromSupabaseDb(date: LocalDateTime): Result<List<TaskItem>> {
        TODO("Not yet implemented")
    }

    override suspend fun breakDownTask(taskRequest: TaskRequest): Result<BreakdownResponse> {
        return try {
            val response = taskService.breakdownTask(taskRequest)
            if (response.isSuccessful && response.body() != null) {
                Result.success(response.body()!!)
            } else {
                Log.e("TaskRepository", "Error response code: ${response.code()}, message: ${response.message()}, body: ${response.errorBody()?.string()}")
                Result.failure(Exception("Failed to fetch data: ${response.message()}"))
            }
        } catch (e: Exception) {
            Log.e("TaskRepository", "Network error: ${e.message}", e)
            Result.failure(Exception("Network error: ${e.message}", e))
        }
    }
}