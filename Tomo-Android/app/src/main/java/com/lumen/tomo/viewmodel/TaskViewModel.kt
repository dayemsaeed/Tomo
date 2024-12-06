package com.lumen.tomo.viewmodel

import android.util.Log
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.SavedStateHandle
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.model.dtos.TaskItemDTO
import com.lumen.tomo.model.llmreponse.TaskRequest
import com.lumen.tomo.model.repository.AuthRepository
import com.lumen.tomo.model.repository.TaskRepository
import com.lumen.tomo.util.Converters
import com.lumen.tomo.util.DataStoreHelper
import dagger.hilt.android.lifecycle.HiltViewModel
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.gotrue.auth
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.UUID
import javax.inject.Inject

@HiltViewModel
class TaskViewModel @Inject constructor(
    private val authRepository: AuthRepository,
    private val supabaseClient: SupabaseClient,
    private val taskRepository: TaskRepository,
    private val dataStoreHelper: DataStoreHelper,
    savedStateHandle: SavedStateHandle
) : ViewModel() {

    private val _taskList = MutableLiveData<List<TaskItem>>()
    val taskList: LiveData<List<TaskItem>> = _taskList

    private val _loading = MutableLiveData<Boolean>()
    val loading: LiveData<Boolean> = _loading

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _description = MutableLiveData<String>()
    val description: LiveData<String> = _description

    private val _selectedDate = MutableLiveData<LocalDate>()
    val selectedDate: LiveData<LocalDate> = _selectedDate

    private val _userId = savedStateHandle.getLiveData<String>("userId")
    val userId: LiveData<String> = _userId

    init {
        _userId.observeForever { id ->
            if (id != null) {
                loadTasksForDate(LocalDate.now())
            }
        }
    }

    fun setUserId(userId: String) {
        _userId.value = userId
    }

    private fun ensureValidSession() {
        viewModelScope.launch {
            try {
                authRepository.refreshTokenIfNeeded()
            } catch (e: Exception) {
                _error.value = "Session refresh failed: ${e.message}"
            }
        }
    }

    fun loadTasksForDate(date: LocalDate) {
        ensureValidSession()
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val userIdValue = userId.value ?: throw IllegalStateException("User ID is null")
                val dateString = date.format(DateTimeFormatter.ISO_LOCAL_DATE)
                Log.i("TaskViewModel", "Loading tasks for userId: $userIdValue on date: $dateString")
                val tasks = taskRepository.getTasksFromSupabaseDb(dateString, userIdValue)
                _taskList.value = tasks.getOrDefault(emptyList()).map { taskDto -> taskDto.asDomainModel() }
            } catch (e: Exception) {
                _error.value = "Error loading tasks: ${e.message}"
            } finally {
                _loading.value = false
            }
        }
    }

    fun addTask(task: TaskItem) {
        ensureValidSession()
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val userIdValue = userId.value ?: throw IllegalStateException("User ID is null")
                val taskWithUserId = task.copy(description = task.description.ifEmpty { " " }, createdBy = userIdValue)
                Log.d("TaskViewModel", "Task: $taskWithUserId")
                val success = taskRepository.insertTaskIntoSupabaseDb(taskWithUserId)
                if (success.isSuccess) {
                    Log.i("TaskViewModel", "Task added successfully. Fetching updated task list.")
                    val tasks = taskRepository.getTasksFromSupabaseDb(Converters.convertToUTC(task.creationDate,
                        DateTimeFormatter.ISO_LOCAL_DATE_TIME.toString()
                    ), userIdValue)
                    _taskList.value = tasks.getOrDefault(emptyList()).map { taskDto -> taskDto.asDomainModel() }
                } else {
                    _error.value = "Error adding task to local database."
                }
            } catch (e: Exception) {
                _error.value = "Error adding task: ${e.message}"
            } finally {
                _loading.value = false
            }
        }
    }

    fun deleteTask(task: TaskItem) {
        ensureValidSession()
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val userIdValue = userId.value ?: throw IllegalStateException("User ID is null")
                val success = taskRepository.deleteTaskFromSupabaseDb(task)
                if (success.isSuccess) {
                    val tasks = taskRepository.getTasksFromSupabaseDb(Converters.convertToUTC(task.creationDate,
                        DateTimeFormatter.ISO_LOCAL_DATE_TIME.toString()
                    ), userIdValue)
                    _taskList.value = tasks.getOrDefault(emptyList()).map { taskDto -> taskDto.asDomainModel() }
                } else {
                    _error.value = "Error deleting task from local database."
                }
            } catch (e: Exception) {
                _error.value = "Error deleting task: ${e.message}"
            } finally {
                _loading.value = false
            }
        }
    }

    fun updateTaskCompletion(task: TaskItem, completed: Boolean) {
        ensureValidSession()
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val userIdValue = userId.value ?: throw IllegalStateException("User ID is null")
                val updatedTask = task.copy(completed = completed)
                taskRepository.updateTaskCompletedInSupabaseDb(updatedTask)
                val tasks = taskRepository.getTasksFromSupabaseDb(Converters.convertToUTC(task.creationDate,
                    DateTimeFormatter.ISO_LOCAL_DATE_TIME.toString()
                ), userIdValue)
                _taskList.value = tasks.getOrDefault(emptyList()).map { taskDto -> taskDto.asDomainModel() }
            } catch (e: Exception) {
                _error.value = "Error updating task: ${e.message}"
            } finally {
                _loading.value = false
            }
        }
    }

    fun updateSelectedDate(date: LocalDate) {
        _selectedDate.value = date
    }

    fun updateTaskDescription(description: String) {
        _description.value = description
    }

    fun generateTaskBreakdown(title: String, description: String) {
        val taskRequest = TaskRequest(title, description)
        viewModelScope.launch {
            try {
                val response = taskRepository.breakDownTask(taskRequest)
                _description.value = response.getOrNull()?.breakdown
            } catch (e: Exception) {
                Log.e("TASK BREAKDOWN", "Error: ${e.message}")
            }
        }
    }

    private fun TaskItemDTO.asDomainModel(): TaskItem {
        return TaskItem(
            id = this.id,
            title = this.title,
            description = this.description,
            creationDate = this.creationDate,
            completed = this.completed,
            color = this.color,
            createdBy = this.createdBy
        )
    }
}
