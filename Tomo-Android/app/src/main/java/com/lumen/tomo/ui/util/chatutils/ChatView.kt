package com.lumen.tomo.ui.util.chatutils

import androidx.compose.foundation.Image
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.imePadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.navigation.NavController
import com.lumen.tomo.R
import com.lumen.tomo.ui.theme.SeherMain
import com.lumen.tomo.viewmodel.ChatViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ChatView(
    navController: NavController,
    chatViewModel: ChatViewModel,
    onSendChatClickListener: (String) -> Unit,
    modifier: Modifier
) {
    Scaffold(
        modifier = modifier.fillMaxSize(),
        topBar = { TopAppBar(
            modifier = Modifier.shadow(elevation = 4.dp),
            title = {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Image(painter = painterResource(id = R.drawable.seher_background), contentDescription = "Seher chat image", modifier = Modifier
                        .clip(CircleShape)
                        .size(32.dp)
                        .border(2.dp, SeherMain, CircleShape)
                    )
                    Spacer(modifier = Modifier.size(8.dp))
                    Text(text = "Seher")
                }
            },
            navigationIcon = {
                Row {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(
                            imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                            contentDescription = "Back button"
                        )
                    }
                }
            }
        ) },
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
                    .padding(horizontal = 8.dp, vertical = 8.dp)
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
}