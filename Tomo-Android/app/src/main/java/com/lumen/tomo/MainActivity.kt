@file:OptIn(ExperimentalMaterial3Api::class)

package com.lumen.tomo

import android.content.res.Configuration.UI_MODE_NIGHT_YES
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.google.firebase.FirebaseApp
import com.lumen.tomo.ui.theme.TomoTheme
import com.lumen.tomo.ui.views.ChatFragment
import com.lumen.tomo.ui.views.LoginFragment
import com.lumen.tomo.ui.views.PetFragment
import com.lumen.tomo.ui.views.RegisterFragment
import com.lumen.tomo.viewmodel.ChatViewModel
import dagger.hilt.android.AndroidEntryPoint

@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    val chatViewModel: ChatViewModel = hiltViewModel()
    NavHost(navController = navController, startDestination = "login") {
        composable("petScreen") { PetFragment(navController) }
        composable("login") { LoginFragment(navController) }
        composable("register") { RegisterFragment(navController) }
        composable("chat") {
            ChatFragment(navController, chatViewModel) { message ->
                chatViewModel.sendMessage(message)
            }
        }
    }
}

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            TomoTheme {
                // A surface container using the 'background' color from the theme
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    AppNavigation()
                }
            }
        }
        FirebaseApp.initializeApp(this)
    }
}