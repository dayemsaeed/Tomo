package com.lumen.tomo.ui.views

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.FabPosition
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.ui.theme.SeherMain
import com.lumen.tomo.ui.util.calendar.WeeklyCalendarView
import com.lumen.tomo.ui.util.task.TaskCard
import com.lumen.tomo.ui.util.task.TaskRow
import com.lumen.tomo.viewmodel.TaskViewModel
import java.time.Instant
import java.time.LocalDateTime
import java.util.Date

@Composable
fun TaskFragment(
    navController: NavController,
    taskViewModel: TaskViewModel
) {
    val taskList by taskViewModel.taskList.observeAsState(emptyList())
    val isLoading by taskViewModel.loading.observeAsState(false)
    val error by taskViewModel.error.observeAsState()

    Scaffold(
        floatingActionButton = {
            FloatingActionButton(
                containerColor = SeherMain,
                contentColor = Color.White,
                onClick = {
                    navController.navigate("addTask")
                },
                modifier = Modifier.padding(16.dp),
                shape = CircleShape
            ) {
                Icon(imageVector = Icons.Default.Add, contentDescription = "Add Task")
            }
        },
        floatingActionButtonPosition = FabPosition.EndOverlay
    ) { padding ->
        Column(
            modifier = Modifier.padding(padding)
        ) {
            WeeklyCalendarView(
                taskViewModel = taskViewModel
            ) {
                navController.popBackStack()
            }
            /*if (isLoading) {
                CircularProgressIndicator(modifier = Modifier.align(Alignment.CenterHorizontally))
            } else {
                error?.let {
                    Text(text = it, color = Color.Red, modifier = Modifier.align(Alignment.CenterHorizontally))
                }

            }*/
            LazyColumn {
                items(taskList, key = { it.id }) { task ->
                    TaskRow(
                        taskItem = task,
                        onTaskCompletionChange = { taskItem, completed ->
                            taskViewModel.updateTaskCompletion(taskItem, completed)
                        },
                        onTaskLongClick = { taskItem ->
                            taskViewModel.deleteTask(taskItem)
                        }
                    )
                }
            }
        }
    }
}
