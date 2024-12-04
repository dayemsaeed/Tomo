package com.lumen.tomo.model

sealed class UserState {
    data object Loading: UserState()
    data class Success(val message: String): UserState()
    data class Error(val message: String): UserState()
}