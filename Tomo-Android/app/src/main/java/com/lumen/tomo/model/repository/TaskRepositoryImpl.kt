package com.lumen.tomo.model.repository

import android.util.Log
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.model.daos.TaskDao
import com.lumen.tomo.model.llmreponse.BreakdownResponse
import com.lumen.tomo.model.llmreponse.TaskRequest
import com.lumen.tomo.model.service.TaskService
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.from
import io.github.jan.supabase.postgrest.query.Order
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import retrofit2.Response
import java.time.LocalDateTime
import java.util.Date
import java.util.UUID
import java.util.logging.Logger
import javax.inject.Inject

class TaskRepositoryImpl @Inject constructor(
    private val taskService: TaskService,
    private val taskDao: TaskDao,
    private val supabaseClient: SupabaseClient
): TaskRepository {
    override suspend fun insertTaskIntoRoomDb(task: TaskItem): Boolean {
        return try {
            taskDao.insertTask(task)
            true
        } catch (e: Exception) {
            Log.e("TaskRepository", "Local insert failed. Message: ${e.message}")
            false
        }
    }

    override suspend fun deleteTaskFromRoomDb(task: TaskItem): Boolean {
        return try {
            taskDao.deleteTask(task)
            true
        } catch (e: Exception) {
            Log.e("TaskRepository", "Local delete failed. Message: ${e.message}")
            false
        }
    }

    override suspend fun getTasksFromRoomDb(date: LocalDateTime, userId: String): List<TaskItem> {
        val startOfDay = date.withHour(0).withMinute(0).withSecond(0).withNano(0)
        val endOfDay = date.withHour(23).withMinute(59).withSecond(59).withNano(999999999)

        Log.i("TaskRepository", "Fetching tasks for userId: $userId from $startOfDay to $endOfDay")

        return try {
            taskDao.getTasksCreatedOnDate(startOfDay, endOfDay, userId)
        } catch (e: Exception) {
            Log.e("TaskRepository", "Local fetch failed. Message: ${e.message}")
            emptyList()
        }
    }

    override suspend fun updateTaskInRoomDb(task: TaskItem): Boolean {
        return try {
            taskDao.updateTask(task)
            true
        } catch (e: Exception) {
            Log.e("TaskRepository", "Local update failed. Message: ${e.message}")
            false
        }
    }

    override suspend fun insertTaskIntoSupabaseDb(task: TaskItem): Result<Boolean> {
        return try {
            withContext(Dispatchers.IO) {
                val response = supabaseClient
                    .from("tasks")
                    .insert(mapOf(
                        "id" to task.id,
                        "title" to task.title,
                        "description" to task.description,
                        "created_at" to task.creationDate.toString(),
                        "completed" to task.completed,
                        "color" to task.color,
                        "created_by" to task.createdBy
                    ))
                if (response.data.isNotEmpty()) {
                    Result.success(true)
                } else {
                    Result.failure(Exception("Could not insert"))
                }
            }
        } catch (e: Exception) {
            Log.e("TaskRepository", "Supabase insert failed. Message: ${e.message}")
            Result.failure(e)
        }
    }

    override suspend fun deleteTaskFromSupabaseDb(task: TaskItem): Result<Boolean> {
        return try {
            withContext(Dispatchers.IO) {
                val response = supabaseClient
                    .from("tasks")
                    .delete {
                        filter {
                            eq("id", task.id.toString())
                            eq("created_by", task.createdBy)
                        }
                    }
                if (response.data.isNotEmpty()) {
                    Result.success(true)
                } else {
                    Result.failure(Exception("Could not fetch data"))
                }
            }
        } catch (e: Exception) {
            Log.e("TaskRepository", "Supabase delete failed. Message: ${e.message}")
            Result.failure(e)
        }
    }

    override suspend fun getTasksFromSupabaseDb(date: LocalDateTime, userId: String): Result<List<TaskItem>> {
        return try {
            withContext(Dispatchers.IO) {
                val dateString = date.toLocalDate().toString()
                val response = supabaseClient
                    .from("tasks")
                    .select {
                        filter {
                            eq("created_at::date", dateString)
                            eq("created_by", userId)
                        }
                        order(column = "created_at", order = Order.ASCENDING)
                    }
                if (response.data.isNotEmpty()) {
                    val tasks = response.decodeList<TaskItem>()
                    Result.success(tasks)
                } else {
                    Result.failure(Exception("Empty response"))
                }
            }
        } catch (e: Exception) {
            Log.e("TaskRepository", "Supabase fetch failed. Message: ${e.message}")
            Result.failure(e)
        }
    }

    override suspend fun breakDownTask(taskRequest: TaskRequest): Result<BreakdownResponse> {
        return try {
            withContext(Dispatchers.IO) {
                val response = taskService.breakdownTask(taskRequest)
                if (response.isSuccessful && response.body() != null) {
                    Result.success(response.body()!!)
                } else {
                    Log.e("TaskRepository", "Error response code: ${response.code()}, message: ${response.message()}, body: ${response.errorBody()?.string()}")
                    Result.failure(Exception("Failed to fetch data: ${response.message()}"))
                }
            }
        } catch (e: Exception) {
            Log.e("TaskRepository", "Network error: ${e.message}", e)
            Result.failure(Exception("Network error: ${e.message}", e))
        }
    }
}