package com.lumen.tomo.ui.util

import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.constraintlayout.compose.Dimension
import com.lumen.tomo.viewmodel.ChatViewModel

@Composable
fun ChatView(
    chatViewModel: ChatViewModel,
    onSendChatClickListener: (String) -> Unit,
    modifier: Modifier
) {
    ConstraintLayout(modifier = modifier.fillMaxSize()) {
        val (messages, chatBox) = createRefs()

        val listState = rememberLazyListState()
        LaunchedEffect(chatViewModel.getNumberOfMessagesInConversation()) {
            listState.animateScrollToItem(chatViewModel.getNumberOfMessagesInConversation())
        }
        LazyColumn(
            state = listState,
            modifier = Modifier
                .fillMaxWidth()
                .constrainAs(messages) {
                    top.linkTo(parent.top)
                    bottom.linkTo(chatBox.top)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                    height = Dimension.fillToConstraints
                },
            contentPadding = PaddingValues(16.dp)
        ) {
            items(chatViewModel.getNumberOfMessagesInConversation()) { item ->
                ChatBubble(chatViewModel.getMessageAtIndex(item))
            }
        }
        ChatBox(
            onSendChatClickListener,
            modifier = Modifier
                .fillMaxWidth()
                .constrainAs(chatBox) {
                    bottom.linkTo(parent.bottom)
                    start.linkTo(parent.start)
                    end.linkTo(parent.end)
                }
        )
    }
}