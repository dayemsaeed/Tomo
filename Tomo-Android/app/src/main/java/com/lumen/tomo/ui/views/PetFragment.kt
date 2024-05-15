package com.lumen.tomo.ui.views

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavController
import com.lumen.tomo.R
import com.lumen.tomo.ui.util.InteractiveLottieAnimation

@Composable
fun PetFragment(
    navController: NavController
) {
    Column {
        Row {
            Button(onClick = {
                navController.navigate("chat")
            }) {
                Text(text = "Chat")
            }
        }
        InteractiveLottieAnimation(initialAnimation = R.raw.cat_idle, tapAnimation = R.raw.cat_headshake, swipeAnimation = R.raw.cat_heart)
    }
}