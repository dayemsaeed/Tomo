package com.lumen.tomo.ui.views

import androidx.compose.foundation.layout.Column
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import com.lumen.tomo.R
import com.lumen.tomo.ui.util.InteractiveLottieAnimation

@Composable
fun NameFragment(modifier: Modifier = Modifier) {
    var name by remember { mutableStateOf("") }
    Column {
        InteractiveLottieAnimation(initialAnimation = R.raw.cat_idle, tapAnimation = R.raw.cat_headshake)
        Text(text = "What's your name?")
        TextField(value = "", onValueChange = {
            name = it
        })
        Button(onClick = { /*TODO*/ }) {
            Text(text = "Next")
        }
    }
}