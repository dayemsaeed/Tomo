package com.lumen.tomo.viewmodel

import android.util.Log
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.model.llmreponse.TaskRequest
import com.lumen.tomo.model.repository.TaskRepository
import dagger.hilt.android.lifecycle.HiltViewModel
import io.github.jan.supabase.SupabaseClient
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.LocalDateTime
import java.util.UUID
import javax.inject.Inject

@HiltViewModel
class TaskViewModel @Inject constructor(
    private val supabaseClient: SupabaseClient,
    private val taskRepository: TaskRepository
): ViewModel() {
    private val _taskList = MutableLiveData<List<TaskItem>>()
    val taskList: LiveData<List<TaskItem>> = _taskList

    private val _loading = MutableLiveData<Boolean>()
    val loading: LiveData<Boolean> = _loading

    private val _error = MutableLiveData<String?>()
    val error: LiveData<String?> = _error

    private val _description = MutableLiveData<String>()
    val description : LiveData<String> = _description

    private val _selectedDate = MutableLiveData<LocalDate>()
    val selectedDate: LiveData<LocalDate> = _selectedDate

    init {
        // Optionally, load tasks for the current date on initialization
        loadTasksForDate(LocalDate.now())
    }

    fun loadTasksForDate(date: LocalDate) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val tasks = taskRepository.getTasksFromRoomDb(date.atStartOfDay())
                _taskList.value = tasks
            } catch (e: Exception) {
                _error.value = "Error loading tasks: ${e.message}"
            } finally {
                _loading.value = false
            }
        }
    }

    fun addTask(task: TaskItem) {
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val success = taskRepository.insertTaskIntoRoomDb(task)
                if (success) {
                    Log.i("TASKADD", "Added task")
                    _taskList.value = taskRepository.getTasksFromRoomDb(task.creationDate)
                    Log.i("TASKFETCH", "Fetched task")
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
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                val success = taskRepository.deleteTaskFromRoomDb(task)
                if (success) {
                    _taskList.value = taskRepository.getTasksFromRoomDb(task.creationDate)
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
        viewModelScope.launch {
            _loading.value = true
            _error.value = null
            try {
                task.completed = completed
                taskRepository.updateTaskInRoomDb(task)
                _taskList.value = taskRepository.getTasksFromRoomDb(task.creationDate)
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
}
