@file:OptIn(ExperimentalMaterial3Api::class)

package com.lumen.tomo.ui.views

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import android.util.Log
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Visibility
import androidx.compose.material.icons.filled.VisibilityOff
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.NavController
import androidx.navigation.compose.rememberNavController
import com.lumen.tomo.R
import com.lumen.tomo.ui.theme.TomoTheme
import com.lumen.tomo.viewmodel.LoginViewModel

@Composable
fun LoginFragment(navController: NavController, modifier: Modifier = Modifier) {
    val loginViewModel: LoginViewModel = hiltViewModel()
    val email by loginViewModel.email.observeAsState("")
    val password by loginViewModel.password.observeAsState("")
    val errorMessage by loginViewModel.errorMessage.observeAsState("")
    val navigateToHome by loginViewModel.navigateToHome.observeAsState(false)
    var startAnimation by remember { mutableStateOf(false) }
    var passwordVisible by remember { mutableStateOf(false) }

    Surface(modifier = modifier.fillMaxSize()) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(30.dp)
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Spacer(modifier = Modifier.weight(0.1f))
                Text(
                    text = "TOMO",
                    style = MaterialTheme.typography.headlineLarge,
                    color = MaterialTheme.colorScheme.primary
                )
                Spacer(modifier = Modifier.weight(0.5f))
                OutlinedTextField(
                    label = { Text(text = stringResource(id = R.string.email_label)) },
                    value = email,
                    onValueChange = { loginViewModel.updateEmail(it) },
                    modifier = modifier
                        .fillMaxWidth()
                )
                Spacer(modifier = Modifier.weight(0.25f))
                OutlinedTextField(
                    label = { Text(text = stringResource(id = R.string.password_label)) },
                    value = password,
                    onValueChange = { loginViewModel.updatePassword(it) },
                    visualTransformation = if (passwordVisible) VisualTransformation.None else PasswordVisualTransformation(),
                    trailingIcon = {
                        val image = if (passwordVisible)
                            Icons.Filled.Visibility
                        else Icons.Filled.VisibilityOff

                        // Please provide localized description for accessibility services
                        val description = if (passwordVisible) "Hide password" else "Show password"

                        IconButton(onClick = {passwordVisible = !passwordVisible}){
                            Icon(imageVector  = image, description)
                        }
                    },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Password),
                    modifier = modifier
                        .fillMaxWidth()
                )
                Spacer(modifier = Modifier.weight(0.5f))
                Button(
                    onClick = {
                        loginViewModel.onLoginClicked()
                        if (navigateToHome) {
                            navController.navigate("petScreen")
                        }
                        else {
                            errorMessage?.let { Log.d("LOGIN ISSUE: ", it) }
                        }
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                ) {
                    Text(text = stringResource(id = R.string.action_sign_in_short))
                }
                Spacer(modifier = Modifier.weight(0.25f))
                Button(
                    onClick = {
                        navController.navigate("register")
                    },
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(50.dp)
                ) {
                    Text(text = stringResource(id = R.string.action_register))
                }
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
        LoginFragment(rememberNavController())
    }
}

@Preview(name="Login-Dark", showBackground = true, uiMode = UI_MODE_NIGHT_YES)
@Composable
fun LoginDarkPreview() {
    TomoTheme {
        LoginFragment(rememberNavController())
    }
}