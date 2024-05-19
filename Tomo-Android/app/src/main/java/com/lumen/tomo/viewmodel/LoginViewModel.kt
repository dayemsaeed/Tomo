package com.lumen.tomo.viewmodel

import android.content.Context
import android.util.Log
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lumen.tomo.model.UserState
import com.lumen.tomo.model.repository.AuthRepository
import com.lumen.tomo.model.repository.AuthRepositoryImpl
import com.lumen.tomo.util.DataStoreHelper
import dagger.hilt.android.lifecycle.HiltViewModel
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.gotrue.auth
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class LoginViewModel @Inject constructor(
    private val authRepository: AuthRepository,
    private val supabaseClient: SupabaseClient,
    private val dataStoreHelper: DataStoreHelper
) : ViewModel() {

    private val _email: MutableLiveData<String> = MutableLiveData("")
    val email: LiveData<String> = _email

    private val _password: MutableLiveData<String> = MutableLiveData("")
    val password: LiveData<String> = _password

    private val _errorMessage: MutableLiveData<String?> = MutableLiveData("")
    val errorMessage: LiveData<String?> = _errorMessage

    private val _navigateToHome: MutableLiveData<Boolean> = MutableLiveData(false)
    val navigateToHome: LiveData<Boolean> = _navigateToHome

    private val _userState: MutableLiveData<UserState> = MutableLiveData(UserState.Loading)
    val userState: LiveData<UserState> = _userState

    fun onLoginClicked() {
        viewModelScope.launch {
            authRepository.logIn(email.value!!, password.value!!,
                onSuccess = {
                    _errorMessage.value = null
                    _navigateToHome.value = true
                    _userState.value = UserState.Success("User successfully logged in!")
                },
                onFailure = { exception ->
                    _errorMessage.value = exception.message
                    _navigateToHome.value = false
                    _userState.value = UserState.Error("User could not be logged in! Error: ${exception.message}")
                }
            )
        }
    }

    private fun saveToken() {
        viewModelScope.launch {
            val accessToken = supabaseClient.auth.currentAccessTokenOrNull() ?: ""
            dataStoreHelper.saveAuthToken(accessToken)
        }
    }

    private fun getToken(): String? {
        var authToken: String? = ""
        viewModelScope.launch {
            try {
                authToken = dataStoreHelper.getAuthToken()
            }
            catch (e: Exception) {
                Log.e("Auth Error", "Could not fetch token. Error: ${e.message}")
            }
        }
        return authToken
    }

    fun updateEmail(newEmail: String) {
        _email.value = newEmail
    }

    fun updatePassword(newPassword: String) {
        _password.value = newPassword
    }

}
