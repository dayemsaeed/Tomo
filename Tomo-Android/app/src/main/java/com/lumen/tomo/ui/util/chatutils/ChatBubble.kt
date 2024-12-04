package com.lumen.tomo.ui.util.chatutils

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
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
import com.lumen.tomo.model.llmreponse.ChatMessage
import com.lumen.tomo.ui.theme.SeherMain
import java.time.LocalDateTime
import java.util.UUID

@Composable
fun ChatBubble(
    message: ChatMessage
) {
    Column(
        modifier = Modifier.fillMaxWidth()
    ) {
        Box(
            modifier = Modifier
                .align(if (message.isSender) Alignment.End else Alignment.Start)
                .clip(
                    RoundedCornerShape(
                        topStart = 64f,
                        topEnd = 64f,
                        bottomStart = if (message.isSender) 64f else 0f,
                        bottomEnd = if (message.isSender) 0f else 64f
                    )
                )
                .background(if (message.isSender) SeherMain else Color.DarkGray)
                .padding(8.dp)
        ) {
            Text(text = message.content, color = if (message.isSender) Color.Black else Color.White)
        }
    }
}

@Preview
@Composable
fun ChatBubbleSenderPreview() {
    ChatBubble(message = ChatMessage(UUID.randomUUID().toString(), UUID.randomUUID().toString(), "Test", true, LocalDateTime.now().toString()))
}

@Preview
@Composable
fun ChatBubbleReceiverPreview() {
    ChatBubble(message = ChatMessage(UUID.randomUUID().toString(), UUID.randomUUID().toString(), "Test", false, LocalDateTime.now().toString()))
}