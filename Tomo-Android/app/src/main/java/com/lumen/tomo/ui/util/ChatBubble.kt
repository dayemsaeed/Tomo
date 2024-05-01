package com.lumen.tomo.ui.util

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.lumen.tomo.R
import com.lumen.tomo.model.ChatMessage
import com.lumen.tomo.ui.theme.Navy
import com.lumen.tomo.ui.theme.Teal80
import java.util.UUID

@Composable
fun ChatBubble(
    message: ChatMessage
) {
    Column {
        Box(
            modifier = Modifier
                .align(if (message.isSender) Alignment.End else Alignment.Start)
                .clip(
                    RoundedCornerShape(
                        topStart = 48f,
                        topEnd = 48f,
                        bottomStart = if (message.isSender) 48f else 0f,
                        bottomEnd = if (message.isSender) 0f else 48f
                    )
                )
                .background(if (message.isSender) Teal80 else Navy)
                .padding(16.dp)
        ) {
            Text(text = message.message, color = if (message.isSender) Color.Black else Color.White)
        }
    }
}

@Preview
@Composable
fun ChatBubbleSenderPreview() {
    ChatBubble(message = ChatMessage(UUID.randomUUID(), "Test", true))
}

@Preview
@Composable
fun ChatBubbleReceiverPreview() {
    ChatBubble(message = ChatMessage(UUID.randomUUID(), "Test", false))
}