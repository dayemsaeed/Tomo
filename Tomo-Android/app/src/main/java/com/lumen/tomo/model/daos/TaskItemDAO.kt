package com.lumen.tomo.model.daos

import androidx.room.*
import com.lumen.tomo.model.TaskItem
import java.time.LocalDateTime

@Dao
interface TaskItemDAO {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertTask(taskItem: TaskItem)

    @Delete
    suspend fun deleteTask(taskItem: TaskItem)

    @Update
    suspend fun updateTask(taskItem: TaskItem)

    @Query("SELECT * FROM taskitem")
    suspend fun getAllTasks(): List<TaskItem>

    @Query("SELECT * FROM taskitem WHERE task_created_by = :userId AND task_created_at BETWEEN :startDate AND :endDate")
    suspend fun getTasksCreatedOnDate(startDate: LocalDateTime, endDate: LocalDateTime, userId: String): List<TaskItem>
}
