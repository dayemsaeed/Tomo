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
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.lumen.tomo.R
import com.lumen.tomo.ui.theme.TomoTheme

@Composable
fun LoginFragment(modifier: Modifier = Modifier) {
    var username by remember { mutableStateOf("") }
    var password by rememberSaveable { mutableStateOf("") }
    var startAnimation by remember { mutableStateOf(false) }

    Surface(modifier = modifier.fillMaxSize()) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(30.dp)
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
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
                    value = username,
                    onValueChange = { username = it },
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
                Spacer(modifier = Modifier.weight(0.5f))
                Button(
                    onClick = {  },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                ) {
                    Text(text = stringResource(id = R.string.action_sign_in_short))
                }
                Spacer(modifier = Modifier.weight(1f))
            }
        }
    }
    LaunchedEffect(Unit) {
        startAnimation = true
    }
}


@Preview(name="Login", showBackground = true)
@Composable
fun LoginPreview() {
    TomoTheme {
        LoginFragment()
    }
}

@Preview(name="Login-Dark", showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun LoginDarkPreview() {
    TomoTheme {
        LoginFragment()
    }
}