package com.lumen.tomo.ui.util.task

import androidx.compose.animation.animateColorAsState
import androidx.compose.animation.core.tween
import androidx.compose.animation.expandHorizontally
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.selection.toggleable
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Check
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.ui.theme.Navy
import com.lumen.tomo.ui.theme.SeherMain
import java.time.LocalDateTime
import java.util.Date

@Composable
fun TaskRow(
    taskItem: TaskItem,
    onTaskCompletionChange: (TaskItem, Boolean) -> Unit,
    onTaskLongClick: (TaskItem) -> Unit
) {
    Row(
        modifier = Modifier
            .padding(8.dp)
            .fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically
    ) {
        val isChecked = remember { mutableStateOf(taskItem.completed) }

        CircularCheckbox(
            isChecked = isChecked.value,
            onValueChange = { checked ->
                isChecked.value = checked
                onTaskCompletionChange(taskItem, checked)
            }
        )
        Spacer(modifier = Modifier.size(8.dp))
        TaskCard(taskItem = taskItem, onTaskLongClick)
    }
}

@Composable
fun CircularCheckbox(
    isChecked: Boolean,
    modifier: Modifier = Modifier,
    size: Float = 24f,
    checkedColor: Color = SeherMain,
    uncheckedColor: Color = Navy,
    onValueChange: (Boolean) -> Unit
) {
    val checkboxColor: Color by animateColorAsState(
        if (isChecked) checkedColor else uncheckedColor,
        label = "Task Checkbox Color"
    )
    val density = LocalDensity.current
    val duration = 200

    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = modifier
            .heightIn(48.dp) // height of 48dp to comply with minimum touch target size
            .toggleable(
                value = isChecked,
                role = Role.Checkbox,
                onValueChange = onValueChange
            )
    ) {
        Box(
            modifier = Modifier
                .size(size.dp)
                .background(color = checkboxColor, shape = CircleShape)
                .border(width = 1.5.dp, color = checkedColor, shape = CircleShape),
            contentAlignment = Alignment.Center
        ) {
            androidx.compose.animation.AnimatedVisibility(
                visible = isChecked,
                enter = slideInHorizontally(animationSpec = tween(duration)) {
                    with(density) { (size * -0.5).dp.roundToPx() }
                } + expandHorizontally(
                    expandFrom = Alignment.Start,
                    animationSpec = tween(duration)
                ),
                exit = fadeOut()
            ) {
                Icon(
                    Icons.Default.Check,
                    contentDescription = null,
                    tint = uncheckedColor
                )
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun TaskRowPreview() {
    TaskRow(
        taskItem = TaskItem(
            title = "Test Task",
            creationDate = LocalDateTime.now(),
            completed = false,
            color = Color.Red.toArgb()
        ),
        onTaskCompletionChange = { task, completed ->
            // Mock implementation for preview
            println("Task '${task.title}' completion changed to $completed")
        },
        onTaskLongClick = {}
    )
}
