package com.lumen.tomo.ui.util.task

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.AccessTime
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.lumen.tomo.model.TaskItem
import com.lumen.tomo.util.DateUtil
import java.time.LocalDateTime
import java.util.Date
import java.util.UUID

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun TaskCard(
    taskItem: TaskItem,
    onTaskLongClick: (TaskItem) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .combinedClickable(
                onClick = {},
                onLongClick = { onTaskLongClick(taskItem) }
            ),
        colors = CardDefaults.cardColors(containerColor = Color(taskItem.color)),
        shape = RoundedCornerShape(8.dp)
    ) {
        Column(
            modifier = Modifier.padding(8.dp),
            horizontalAlignment = Alignment.Start
        ) {
            Text(
                modifier = Modifier.padding(vertical = 4.dp),
                text = taskItem.title,
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold
            )
            Row(
                modifier = Modifier.padding(vertical = 4.dp),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(
                    imageVector = Icons.Outlined.AccessTime,
                    contentDescription = "Clock icon: Event time"
                )
                Text(
                    modifier = Modifier.padding(horizontal = 8.dp),
                    text = taskItem.creationDate.toLocalTime().format(DateUtil.timeFormatter),
                    fontWeight = FontWeight.SemiBold
                )
            }
        }
    }
}

@Preview
@Composable
fun TaskCardPreview() {
    TaskCard(TaskItem(title = "Test Task", creationDate = LocalDateTime.now(), completed = false, color = Color.Red.toArgb(), createdBy = UUID.randomUUID())) {}
}