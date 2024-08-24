@file:OptIn(ExperimentalMaterial3Api::class)

package com.lumen.tomo

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.google.firebase.FirebaseApp
import com.lumen.tomo.model.BreathingPattern
import com.lumen.tomo.ui.theme.TomoTheme
import com.lumen.tomo.ui.util.breathing.BreathingExercise
import com.lumen.tomo.ui.views.AddTaskFragment
import com.lumen.tomo.ui.views.ChatFragment
import com.lumen.tomo.ui.views.LoginFragment
import com.lumen.tomo.ui.views.BreathingFragment
import com.lumen.tomo.ui.views.PetFragment
import com.lumen.tomo.ui.views.RegisterFragment
import com.lumen.tomo.ui.views.TaskFragment
import com.lumen.tomo.viewmodel.BreathingViewModel
import com.lumen.tomo.viewmodel.ChatViewModel
import com.lumen.tomo.viewmodel.LoginViewModel
import com.lumen.tomo.viewmodel.TaskViewModel
import dagger.hilt.android.AndroidEntryPoint

@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    val chatViewModel: ChatViewModel = hiltViewModel()
    val taskViewModel: TaskViewModel = hiltViewModel()
    val breathViewModel: BreathingViewModel = hiltViewModel()
    NavHost(navController = navController, startDestination = "login") {
        composable("petScreen") { PetFragment(navController) }
        composable("login") { LoginFragment(navController) }
        composable("register") { RegisterFragment(navController) }
        composable("tasks") { TaskFragment(navController, taskViewModel) }
        composable("addTask") { AddTaskFragment(navController, taskViewModel) }
        composable("breathe") { BreathingFragment(navController, breathViewModel) }
        composable("breathe/{pattern}") {
            val patternName = it.arguments?.getString("pattern")
            val pattern = BreathingPattern.valueOf(patternName ?: "BOX_BREATHING")
            BreathingExercise(viewModel = breathViewModel)
        }
        composable("chat") {
            ChatFragment(navController, chatViewModel) { message ->
                chatViewModel.sendMessage(message)
            }
        }
    }
}

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    private val loginViewModel: LoginViewModel by viewModels()
    private val taskViewModel: TaskViewModel by viewModels()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        loginViewModel.userId.observe(this) { userId ->
            if (userId != null && userId.isNotEmpty()) {
                taskViewModel.setUserId(userId)
            }
            else {
                Log.i("MainActivity", "User Id: $userId")
            }
        }
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