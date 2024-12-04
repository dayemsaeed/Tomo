package com.lumen.tomo.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.lumen.tomo.model.UserState
import com.lumen.tomo.model.repository.AuthRepository
import com.lumen.tomo.util.DataStoreHelper
import dagger.hilt.android.lifecycle.HiltViewModel
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.gotrue.auth
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

    private val _userId: MutableLiveData<String> = MutableLiveData(null)
    val userId: LiveData<String> = _userId

    init {
        restoreSession()
    }

    fun onLoginClicked() {
        viewModelScope.launch {
            authRepository.logIn(email.value!!, password.value!!,
                onSuccess = {
                    saveSession()
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

    private fun saveSession() {
        viewModelScope.launch {
            val session = supabaseClient.auth.currentSessionOrNull()
            session?.let {
                dataStoreHelper.saveTokens(it.accessToken, it.refreshToken)
                _userId.value = it.user?.id
            }
        }
    }

    private fun restoreSession() {
        viewModelScope.launch {
            val session = dataStoreHelper.getAccessToken()
            if (session != null) {
                dataStoreHelper.getRefreshToken()?.let { supabaseClient.auth.refreshSession(it) }
                _userId.value = supabaseClient.auth.currentSessionOrNull()?.user?.id
            }
            checkUserState()
        }
    }

    private fun checkUserState() {
        val currentUser = supabaseClient.auth.currentUserOrNull()
        if (currentUser != null) {
            _navigateToHome.value = true
            _userState.value = UserState.Success("User is logged in")
        } else {
            _navigateToHome.value = false
            _userState.value = UserState.Error("No user logged in")
        }
    }

    fun updateEmail(newEmail: String) {
        _email.value = newEmail
    }

    fun updatePassword(newPassword: String) {
        _password.value = newPassword
    }
}

