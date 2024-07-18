package com.lumen.tomo.model.repository

import android.util.Log
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.model.daos.TaskItemDAO
import com.lumen.tomo.model.dtos.TaskItemDTO
import com.lumen.tomo.model.llmreponse.BreakdownResponse
import com.lumen.tomo.model.llmreponse.TaskRequest
import com.lumen.tomo.model.service.TaskService
import com.lumen.tomo.model.toDTO
import com.lumen.tomo.util.Converters
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.postgrest.from
import io.github.jan.supabase.postgrest.query.Order
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.ZoneOffset
import java.time.format.DateTimeFormatter
import javax.inject.Inject

class TaskRepositoryImpl @Inject constructor(
    private val taskService: TaskService,
    private val taskDao: TaskItemDAO,
    private val supabaseClient: SupabaseClient
) : TaskRepository {

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

    override suspend fun getTasksFromRoomDb(date: String, userId: String): List<TaskItem> {
        val localDate = LocalDateTime.parse(date)
        val startOfDay = localDate.withHour(0).withMinute(0).withSecond(0).withNano(0)
        val endOfDay = localDate.withHour(23).withMinute(59).withSecond(59).withNano(999999999)

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
                val taskDTO = task.toDTO()
                val jsonString = Json.encodeToString(taskDTO)
                Log.d("TaskRepository", "JSON String: $jsonString")
                val response = supabaseClient
                    .from("tasks")
                    .insert(taskDTO)
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
                            eq("id", task.id)
                            eq("task_created_by", task.createdBy)
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

    override suspend fun getTasksFromSupabaseDb(date: String, userId: String): Result<List<TaskItemDTO>> {
        return try {
            withContext(Dispatchers.IO) {
                // Parse the local date string to LocalDate
                val localDate = LocalDate.parse(date, DateTimeFormatter.ISO_LOCAL_DATE)

                // Convert the date to UTC start and end times in the correct format
                val startOfDayUTC = localDate.atStartOfDay(ZoneOffset.UTC).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                val endOfDayUTC = localDate.atTime(LocalTime.MAX).atZone(ZoneOffset.UTC).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                Log.i("TaskRepository", "Fetching tasks for userId: $userId from $startOfDayUTC to $endOfDayUTC")

                // Query Supabase
                val response = supabaseClient
                    .from("tasks")
                    .select {
                        filter {
                            and {
                                gte("task_created_at", startOfDayUTC)
                                lte("task_created_at", endOfDayUTC)
                                eq("task_created_by", userId)
                            }
                        }
                        order("task_created_at", Order.ASCENDING)
                    }

                if (response.data.isNotEmpty()) {
                    val tasks = response.decodeList<TaskItemDTO>()
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

    override suspend fun updateTaskCompletedInSupabaseDb(task: TaskItem): Result<Boolean> {
        return try {
            withContext(Dispatchers.IO) {
                val response = supabaseClient
                    .from("tasks")
                    .update(
                        {
                            set("task_completed", task.completed)
                        }
                    ) {
                        filter {
                            eq("id", task.id)
                        }
                    }
                if (response.data.isNotEmpty()) {
                    Result.success(true)
                } else {
                    Result.failure(Exception("Could not update data"))
                }
            }
        } catch (e: Exception) {
            Log.e("TaskRepository", "Supabase update failed. Message: ${e.message}")
            Result.failure(e)
        }
    }

    override suspend fun getAllTasksFromSupabaseDb(): Result<List<TaskItemDTO>> {
        return try {
            withContext(Dispatchers.IO) {
                val response = supabaseClient
                    .from("tasks")
                    .select {
                        order(column = "task_created_at", order = Order.ASCENDING)
                    }
                    .decodeList<TaskItemDTO>()

                if (response.isNotEmpty()) {
                    Result.success(response)
                }
                else {
                    Result.failure(Exception("Could not get all tasks"))
                }
            }
        }
        catch (e: Exception) {
            Log.e("TaskRepository", "Supabase fetch failed. Message: ${e.message}")
            Result.failure(e)
        }
    }
}