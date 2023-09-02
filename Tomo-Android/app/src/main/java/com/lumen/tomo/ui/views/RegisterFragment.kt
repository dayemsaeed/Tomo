@file:OptIn(ExperimentalMaterial3Api::class)

package com.lumen.tomo.ui.views

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.lumen.tomo.R
import com.lumen.tomo.ui.animatedcomponents.Bubble
import com.lumen.tomo.ui.theme.TomoTheme

@Composable
fun Register(modifier: Modifier = Modifier) {
    var email by remember { mutableStateOf("") }
    var password by rememberSaveable { mutableStateOf("") }
    var confirmPassword by rememberSaveable { mutableStateOf("") }
    var startAnimation by remember { mutableStateOf(false) }

    Surface(
        modifier = Modifier.fillMaxSize()
    ) {
        Box(modifier = modifier
            .fillMaxSize()
        ) {

            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                modifier = Modifier.padding(30.dp)
            ) {
                Spacer(modifier = Modifier.weight(1f))
                Text(
                    text = "TOMO",
                    style = MaterialTheme.typography.headlineLarge,
                    color = MaterialTheme.colorScheme.primary
                )
                Spacer(modifier = Modifier.weight(0.5f))
                OutlinedTextField(
                    label = { Text(text = stringResource(id = R.string.email_label)) },
                    value = email,
                    onValueChange = { email = it },
                    modifier = modifier
                        .fillMaxWidth()
                )
                Spacer(modifier = Modifier.weight(0.25f))
                OutlinedTextField(
                    label = { Text(text = stringResource(id = R.string.password_label)) },
                    value = password,
                    onValueChange = { password = it },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                    modifier = modifier
                        .fillMaxWidth()
                )
                Spacer(modifier = Modifier.weight(0.25f))
                OutlinedTextField(
                    label = { Text(text = stringResource(id = R.string.confirm_password_label)) },
                    value = confirmPassword,
                    onValueChange = { confirmPassword = it },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                    modifier = modifier
                        .fillMaxWidth()
                )
                Spacer(modifier = Modifier.weight(0.5f))
                Button(
                    onClick = {  },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                ) {
                    Text(text = stringResource(id = R.string.action_register))
                }
            }
            // Bubble
            Bubble(
                startAnimation = startAnimation,
                position1 = Offset(-110f, -180f),
                position2 = Offset(-180f, -90f)
            )
        }
    }
    LaunchedEffect(Unit) {
        startAnimation = true
    }
}


@Preview(showBackground = true)
@Composable
fun RegisterPreview() {
    TomoTheme {
        Register()
    }
}

@Preview(showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun RegisterDarkPreview() {
    TomoTheme {
        Register()
    }
}