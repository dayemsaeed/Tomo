package com.lumen.tomo.ui.views

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.lumen.tomo.R
import com.lumen.tomo.ui.util.InteractiveLottieAnimation

@Composable
fun PetFragment(
    navController: NavController
) {
    Column(
        modifier = Modifier.fillMaxSize()
            .padding(8.dp)
    ) {
        InteractiveLottieAnimation(modifier = Modifier.weight(7f), initialAnimation = R.raw.cat_idle, tapAnimation = R.raw.cat_headshake, swipeAnimation = R.raw.cat_heart)
        Row(
            modifier = Modifier.fillMaxWidth()
                .weight(1f),
            horizontalArrangement = Arrangement.SpaceEvenly
        ) {
            Button(onClick = {
                navController.navigate("chat")
            }) {
                Text(text = "Chat")
            }
            Button(onClick = {
                navController.navigate("tasks")
            }) {
                Text(text = "Tasks")
            }
            Button(onClick = {
                navController.navigate("breathe")
            }) {
                Text(text = "Breathe")
            }
        }
    }
}