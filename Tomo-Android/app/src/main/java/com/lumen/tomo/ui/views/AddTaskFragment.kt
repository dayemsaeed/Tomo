package com.lumen.tomo.ui.views

import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Close
import androidx.compose.material3.BottomAppBar
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DatePicker
import androidx.compose.material3.DatePickerDialog
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.material3.SnackbarHostState
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberDatePickerState
import androidx.compose.material3.rememberTimePickerState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import com.lumen.tomo.R
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.ui.theme.Navy
import com.lumen.tomo.ui.theme.PastelPink
import com.lumen.tomo.ui.theme.PastelYellow
import com.lumen.tomo.ui.theme.Purple80
import com.lumen.tomo.ui.theme.PurpleGrey40
import com.lumen.tomo.ui.theme.SeherLighter
import com.lumen.tomo.ui.theme.SeherMain
import com.lumen.tomo.ui.util.GradientButton
import com.lumen.tomo.ui.util.calendar.TimePickerDialog
import com.lumen.tomo.viewmodel.TaskViewModel
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.Calendar
import java.util.UUID


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddTaskFragment(
    navController: NavController,
    taskViewModel: TaskViewModel
) {

    var taskTitle by remember { mutableStateOf("") }
    val taskDescription by taskViewModel.description.observeAsState("")
    val datePickerState = rememberDatePickerState()
    var date by remember { mutableStateOf(LocalDate.now()) }
    var time by remember { mutableStateOf(LocalTime.now()) }
    var selectedColor by remember { mutableStateOf(SeherMain) }
    var openDatePicker by remember { mutableStateOf(false) }
    var openTimePicker by remember { mutableStateOf(false) }
    val formatter = remember { DateTimeFormatter.ofPattern("hh:mm a") }
    val scope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }

    Scaffold(
        snackbarHost = {
            SnackbarHost(hostState = snackbarHostState)
        },
        topBar = { AddTaskTopAppBar(navController = navController) },
        bottomBar = { AddTaskBottomBar(navController = navController) {
            Log.i("AddTaskFragment", "User Id: ${taskViewModel.userId.value}")
            taskViewModel.addTask(
                TaskItem(title = taskTitle, creationDate = date.atTime(time).toString(), color = selectedColor.toArgb(), createdBy = taskViewModel.userId.value.toString(), completed = false, description = taskDescription)
            )
            taskViewModel.updateTaskDescription("")
        }
        }
    ) { paddingValue ->
        Column(
            modifier = Modifier
                .padding(paddingValue)
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 16.dp),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            OutlinedTextField(
                modifier = Modifier.fillMaxWidth(),
                label = { Text(text = "Task Title") },
                value = taskTitle,
                onValueChange = {
                    taskTitle = it
                }
            )
            Spacer(modifier = Modifier.size(16.dp))
            TextField(
                value = date.toString(),
                onValueChange = {},
                enabled = false,
                label = { Text(text = "Date") },
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable {
                        openDatePicker = true
                    }
            )

            if (openDatePicker) {
                DatePickerDialog(
                    onDismissRequest = { openDatePicker = false },
                    confirmButton = {
                        TextButton(onClick = {
                            val selectedDateMillis = datePickerState.selectedDateMillis
                            if (selectedDateMillis != null) {
                                date = LocalDate.ofEpochDay(selectedDateMillis / (24 * 60 * 60 * 1000))
                            }
                            openDatePicker = false
                        }) {
                            Text(text = "OK")
                        }
                    },
                    dismissButton = {
                        TextButton(onClick = { openDatePicker = false }) {
                            Text(text = "Cancel")
                        }
                    }
                ) {
                    DatePicker(state = datePickerState)
                }
            }

            Spacer(modifier = Modifier.size(16.dp))

            TextField(
                value = time.format(formatter).toString(),
                onValueChange = {},
                enabled = false,
                label = { Text(text = "Time") },
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable {
                        openTimePicker = true
                    }
            )

            if (openTimePicker) {
                TimePickerDialog(onCancel = { openTimePicker = false }, onConfirm = {
                    time = LocalTime.of(it.get(Calendar.HOUR_OF_DAY), it.get(Calendar.MINUTE))
                    openTimePicker = false
                })
            }

            Spacer(modifier = Modifier.size(16.dp))

            OutlinedTextField(
                label = { Text(text = "Description") },
                placeholder = { Text(text = "Add a short description for your task (optional)") },
                value = taskDescription,
                onValueChange = {
                    taskViewModel.updateTaskDescription(it)
                },
                modifier = Modifier.fillMaxWidth(),
                minLines = 4
            )

            Spacer(modifier = Modifier.size(8.dp))

            GradientButton(
                buttonText = "Generate with AI",
                textColor = Color.White,
                gradient = Brush.horizontalGradient(
                    colors = listOf(
                        SeherMain,
                        SeherLighter
                    )
                )
            ) {
                if (taskDescription.isEmpty()) {
                    scope.launch {
                        snackbarHostState.showSnackbar("Please enter a short description of the task first")
                    }
                }
                else {
                    taskViewModel.generateTaskBreakdown(taskTitle, taskDescription)
                }
            }

            Spacer(modifier = Modifier.size(16.dp))

            Text(text = "Color")

            Spacer(modifier = Modifier.size(8.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(SeherMain)
                        .clickable {
                            selectedColor = SeherMain
                        }
                        .border(
                            2.dp,
                            if (selectedColor == SeherMain) Navy else PurpleGrey40,
                            CircleShape
                        )
                        .size(40.dp)
                )

                Spacer(modifier = Modifier.size(8.dp))

                Box(
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(Purple80)
                        .clickable {
                            selectedColor = Purple80
                        }
                        .border(
                            2.dp,
                            if (selectedColor == Purple80) Navy else PurpleGrey40,
                            CircleShape
                        )
                        .size(40.dp)
                )

                Spacer(modifier = Modifier.size(8.dp))

                Box(
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(PastelYellow)
                        .clickable {
                            selectedColor = PastelYellow
                        }
                        .border(
                            2.dp,
                            if (selectedColor == PastelYellow) Navy else PurpleGrey40,
                            CircleShape
                        )
                        .size(40.dp)
                )

                Spacer(modifier = Modifier.size(8.dp))

                Box(
                    modifier = Modifier
                        .clip(CircleShape)
                        .background(PastelPink)
                        .clickable {
                            selectedColor = PastelPink
                        }
                        .border(
                            2.dp,
                            if (selectedColor == PastelPink) Navy else PurpleGrey40,
                            CircleShape
                        )
                        .size(40.dp)
                )
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddTaskTopAppBar(navController: NavController) {
    TopAppBar(
        title = { Text(text = "Add New Task") },
        navigationIcon = {
            IconButton(onClick = { navController.navigateUp() }) {
                Icon(imageVector = Icons.Outlined.Close, contentDescription = "Close Task")
            }
        }
    )
}

@Composable
fun AddTaskBottomBar(navController: NavController, onClick: () -> Unit) {
    BottomAppBar(
        modifier = Modifier.fillMaxWidth()
    ) {
        Button(
            modifier = Modifier.fillMaxWidth(),
            colors = ButtonDefaults.buttonColors(containerColor = SeherMain),
            onClick = {
                onClick()
                navController.navigateUp()
            }
        ) {
            Text(
                text = "Save"
            )
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun AddTaskFragmentWithoutVM(
    navController: NavController
) {
    var task by remember {
        mutableStateOf(
            TaskItem(
                title = "",
                creationDate = LocalDateTime.now().toString(),
                completed = false,
                color = R.color.navy,
                createdBy = UUID.randomUUID().toString()
            )
        )
    }

    var taskTitle by remember { mutableStateOf("") }
    var taskDescription by remember { mutableStateOf("") }
    val datePickerState = rememberDatePickerState()
    val timePickerState = rememberTimePickerState()
    var date by remember { mutableStateOf(LocalDate.now()) }
    var time by remember { mutableStateOf(LocalTime.now()) }
    var openDatePicker by remember { mutableStateOf(false) }
    var openTimePicker by remember { mutableStateOf(false) }
    val formatter = remember { DateTimeFormatter.ofPattern("hh:mm a") }
    val scope = rememberCoroutineScope()
    val snackbarHostState = remember { SnackbarHostState() }

    Scaffold(
        snackbarHost = {
            SnackbarHost(hostState = snackbarHostState)
        },
        topBar = { AddTaskTopAppBar(navController = navController) },
        bottomBar = { AddTaskBottomBar(navController = navController, {}) }
    ) { paddingValue ->
        Column(
            modifier = Modifier
                .padding(paddingValue)
                .padding(horizontal = 8.dp),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            OutlinedTextField(
                modifier = Modifier.fillMaxWidth(),
                label = { Text(text = "Task Title") },
                value = taskTitle,
                onValueChange = {
                    taskTitle = it
                }
            )
            Spacer(modifier = Modifier.size(16.dp))
            TextField(
                value = date.toString(),
                onValueChange = {},
                enabled = false,
                label = { Text(text = "Date") },
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable {
                        openDatePicker = true
                    }
            )

            if (openDatePicker) {
                DatePickerDialog(
                    onDismissRequest = { openDatePicker = false },
                    confirmButton = {
                        TextButton(onClick = {
                            val selectedDateMillis = datePickerState.selectedDateMillis
                            if (selectedDateMillis != null) {
                                date = LocalDate.ofEpochDay(selectedDateMillis / (24 * 60 * 60 * 1000))
                            }
                            openDatePicker = false
                        }) {
                            Text(text = "OK")
                        }
                    },
                    dismissButton = {
                        TextButton(onClick = { openDatePicker = false }) {
                            Text(text = "Cancel")
                        }
                    }
                ) {
                    DatePicker(state = datePickerState)
                }
            }

            Spacer(modifier = Modifier.size(16.dp))

            TextField(
                value = time.format(formatter).toString(),
                onValueChange = {},
                enabled = false,
                label = { Text(text = "Time") },
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable {
                        openTimePicker = true
                    }
            )

            if (openTimePicker) {
                TimePickerDialog(onCancel = { openTimePicker = false }, onConfirm = {
                    time = LocalTime.of(it.get(Calendar.HOUR_OF_DAY), it.get(Calendar.MINUTE))
                    Log.i("LocLTIME", "HR: ${timePickerState.hour} MIN: ${timePickerState.minute}")
                    openTimePicker = false
                })
            }

            OutlinedTextField(
                label = { Text(text = "Description") },
                placeholder = { Text(text = "Add a short description for your task (optional)") },
                value = taskDescription,
                onValueChange = {
                    taskDescription = it
                },
                modifier = Modifier.fillMaxWidth(),
                minLines = 4
            )
            GradientButton(
                buttonText = "Generate with AI",
                textColor = Color.White,
                gradient = Brush.horizontalGradient(
                    colors = listOf(
                        SeherMain,
                        SeherLighter
                    )
                )
            ) {
                if (taskDescription.isEmpty()) {
                    scope.launch {
                        snackbarHostState.showSnackbar("Please enter a short description of the task first")
                    }
                }
            }
        }
    }
}

@Preview
@Composable
fun AddTaskFragmentPreview() {
    AddTaskFragmentWithoutVM(navController = rememberNavController())
}
