package com.lumen.tomo.di

import android.content.Context
import androidx.room.Room
import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase
import com.lumen.tomo.model.daos.TaskItemDAO
import com.lumen.tomo.util.Converters
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent
import javax.inject.Singleton

@InstallIn(SingletonComponent::class)
@Module
class DatabaseModule {

    @Singleton
    @Provides
    fun provideAppDatabase(@ApplicationContext context: Context): AppDatabase {
        return Room.databaseBuilder(
            context,
            AppDatabase::class.java,
            "SeherDatabase"
        )
            .addMigrations(MIGRATION_1_2)
            .addTypeConverter(Converters())
            .build()
    }

    @Provides
    fun provideTaskDao(appDatabase: AppDatabase): TaskItemDAO {
        return appDatabase.taskDao()
    }

    private val MIGRATION_1_2 = object : Migration(1, 2) {
        override fun migrate(db: SupportSQLiteDatabase) {
            // Drop the existing table
            db.execSQL("DROP TABLE IF EXISTS TaskItem")

            // Create the new table
            db.execSQL("""
                CREATE TABLE IF NOT EXISTS taskItem (
                    id BLOB NOT NULL PRIMARY KEY, 
                    task_title TEXT NOT NULL, 
                    task_created_at TEXT NOT NULL, 
                    task_completed INTEGER NOT NULL, 
                    task_tint INTEGER NOT NULL, 
                    task_description TEXT NOT NULL DEFAULT ''
                )
            """)
        }
    }
}