package com.lumen.tomo.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.lumen.tomo.model.repository.AuthRepository

class LoginViewModel : ViewModel() {

    private val _email: MutableLiveData<String> = MutableLiveData("")
    val email: LiveData<String> = _email

    private val _password: MutableLiveData<String> = MutableLiveData("")
    val password: LiveData<String> = _password

    private val _errorMessage: MutableLiveData<String?> = MutableLiveData("")
    val errorMessage: LiveData<String?> = _errorMessage

    private val _navigateToHome: MutableLiveData<Boolean> = MutableLiveData(false)
    val navigateToHome: LiveData<Boolean> = _navigateToHome

    private val authRepository = AuthRepository()

    fun onLoginClicked() {
        authRepository.logIn(email.value!!, password.value!!,
            onSuccess = {
                _errorMessage.value = null
                _navigateToHome.value = true
            },
            onFailure = { exception ->
                _errorMessage.value = exception.message
                _navigateToHome.value = false
            }
        )
    }

}