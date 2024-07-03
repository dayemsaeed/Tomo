package com.lumen.tomo.di

import android.app.Application
import androidx.room.AutoMigration
import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.model.daos.TaskDao
import com.lumen.tomo.util.Converters
import dagger.hilt.android.HiltAndroidApp

@Database(
    entities = [TaskItem::class],
    autoMigrations = [
        AutoMigration (
            from = 2,
            to = 3
        )
    ],
    version = 3
)
@TypeConverters(Converters::class)
abstract class AppDatabase : RoomDatabase() {

    abstract fun taskDao(): TaskDao

}
@HiltAndroidApp
class MyApplication: Application() {
}