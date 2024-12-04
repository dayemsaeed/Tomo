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
class RegisterViewModel @Inject constructor(
    private val supabaseClient: SupabaseClient,
    private val authRepository: AuthRepository,
    private val dataStoreHelper: DataStoreHelper
) : ViewModel() {

    private var _email: MutableLiveData<String> = MutableLiveData<String>("")
    var email: LiveData<String> = _email

    private var _password: MutableLiveData<String> = MutableLiveData("")
    var password: LiveData<String> = _password

    private var _confirmPassword: MutableLiveData<String> = MutableLiveData("")
    var confirmPassword: LiveData<String> = _confirmPassword

    private val _errorMessage: MutableLiveData<String?> = MutableLiveData("")
    val errorMessage: LiveData<String?> = _errorMessage

    private val _navigateToHome: MutableLiveData<Boolean> = MutableLiveData(false)
    val navigateToHome: LiveData<Boolean> = _navigateToHome

    private val _userState: MutableLiveData<UserState> = MutableLiveData(UserState.Loading)
    val userState: LiveData<UserState> = _userState

    fun onRegisterClicked() {
        viewModelScope.launch {
            authRepository.register(email.value!!, password.value!!,
                onSuccess = {
                    _errorMessage.value = null
                    _navigateToHome.value = true
                    _userState.value = UserState.Success("User successfully registered!")
                },
                onFailure = { exception ->
                    _errorMessage.value = exception.message
                    _navigateToHome.value = false
                    _userState.value = UserState.Error("User could not be registered! Error: ${exception.message}")
                }
            )
        }
    }

    private fun saveSession() {
        viewModelScope.launch {
            val session = supabaseClient.auth.currentSessionOrNull()
            session?.let {
                dataStoreHelper.saveTokens(it.accessToken, it.refreshToken)
            }
        }
    }

    private fun restoreSession() {
        viewModelScope.launch {
            val session = dataStoreHelper.getAccessToken()
            if (session != null) {
                dataStoreHelper.getRefreshToken()?.let { supabaseClient.auth.refreshSession(it) }
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