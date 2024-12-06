package com.lumen.tomo.ui.views

import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import com.lumen.tomo.ui.util.chatutils.ChatView
import com.lumen.tomo.viewmodel.ChatViewModel

@Composable
fun ChatFragment(
    navController: NavController,
    chatViewModel: ChatViewModel,
    modifier: Modifier = Modifier,
    onSendChatListener: (String) -> Unit
) {
    // Load messages when the fragment is first composed
    chatViewModel.loadMessages()

    // Display the chat view
    ChatView(
        navController = navController,
        chatViewModel = chatViewModel,
        onSendChatClickListener = onSendChatListener,
        modifier = modifier
    )
}
