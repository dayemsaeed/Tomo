package com.lumen.tomo.model.daos

import androidx.room.*
import com.lumen.tomo.model.TaskItem

@Dao
interface TaskDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertTask(taskItem: TaskItem)

    @Delete
    suspend fun deleteTask(taskItem: TaskItem)

    @Update
    suspend fun updateTask(taskItem: TaskItem)

    @Query("SELECT * FROM taskitem")
    suspend fun getAllTasks(): List<TaskItem>

    @Query("SELECT * FROM taskitem WHERE DATE(task_created_at) = DATE(:date) ORDER BY task_created_at ASC")
    suspend fun getTasksCreatedOnDate(date: String): List<TaskItem>
}
