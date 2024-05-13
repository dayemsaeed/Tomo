package com.lumen.tomo.ui.util

import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.constraintlayout.compose.ConstraintLayout
import com.lumen.tomo.viewmodel.ChatViewModel

@Composable
fun ChatView(
    chatViewModel: ChatViewModel,
    onSendChatClickListener: (String) -> Unit,
    modifier: Modifier
) {
    Scaffold(
        modifier = modifier.fillMaxSize(),
        bottomBar = { ChatInputBox(onSendChatClickListener, modifier = Modifier.fillMaxWidth()) }  // We move the ChatBox to a bottomBar to better manage layout
    ) { innerPadding ->
        ConstraintLayout(modifier = Modifier.padding(innerPadding)) {
            val (messages) = createRefs()

            val listState = rememberLazyListState()
            val messageList by chatViewModel.messages.collectAsState()

            LaunchedEffect(messageList.size) {  // Trigger scroll when the number of messages changes
                listState.animateScrollToItem(if (messageList.isEmpty()) 0 else messageList.size - 1) // Scroll to last item instead of the first
            }

            LazyColumn(
                state = listState,
                modifier = Modifier
                    .fillMaxWidth()
                    .constrainAs(messages) {
                        top.linkTo(parent.top)
                        bottom.linkTo(parent.bottom)
                        start.linkTo(parent.start)
                        end.linkTo(parent.end)
                    }
                    .imePadding(), // Apply imePadding to adjust for the keyboard
            ) {
                items(messageList.size) { index ->
                    ChatBubble(messageList[index])
                    Spacer(modifier = Modifier.size(16.dp))
                }
            }
        }
    }
    /*ChatInputBox(
        onSendChatClickListener,
        modifier = Modifier
            .fillMaxWidth()
            *//*.constrainAs(chatBox) {
                bottom.linkTo(parent.bottom)
                start.linkTo(parent.start)
                end.linkTo(parent.end)
            }*//*
    )*/
}