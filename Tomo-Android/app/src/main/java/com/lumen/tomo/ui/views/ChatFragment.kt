package com.lumen.tomo.ui.views

import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.navigation.NavController
import com.lumen.tomo.R
import com.lumen.tomo.ui.util.ChatView
import com.lumen.tomo.ui.util.InteractiveLottieAnimation
import com.lumen.tomo.viewmodel.ChatViewModel

@Composable
fun ChatFragment(
    navController: NavController,
    chatViewModel: ChatViewModel,
    modifier: Modifier = Modifier,
    onSendChatListener: (String) -> Unit
) {
    val initialAnimation = R.raw.cat_idle  // Initial animation resource ID
    val tapAnimation = R.raw.cat_headshake          // Tap specific animation resource ID
    val swipeAnimation = R.raw.cat_heart      // Swipe specific animation resource ID

    InteractiveLottieAnimation(
        initialAnimation = initialAnimation,
        tapAnimation = tapAnimation,
        swipeAnimation = swipeAnimation
    )

    ChatView(chatViewModel = chatViewModel, onSendChatClickListener = onSendChatListener, modifier = modifier)
}
