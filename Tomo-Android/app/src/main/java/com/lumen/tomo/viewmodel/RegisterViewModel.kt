package com.lumen.tomo.viewmodel

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.lumen.tomo.model.repositories.AuthRepository

class RegisterViewModel : ViewModel() {

    val authRepository = AuthRepository()

    private var _email: MutableLiveData<String> = MutableLiveData<String>("")
    var email: LiveData<String> = _email

    private var _password: MutableLiveData<String> = MutableLiveData("")
    var password: LiveData<String> = _password

    private var _confirmPassword: MutableLiveData<String> = MutableLiveData("")
    var confirmPassword: LiveData<String> = _confirmPassword

}