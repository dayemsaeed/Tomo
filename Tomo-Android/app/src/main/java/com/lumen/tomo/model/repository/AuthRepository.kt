package com.lumen.tomo.model.repository

interface AuthRepository {
    suspend fun logIn(email: String, password: String, onSuccess: () -> Unit, onFailure: (Exception) -> Unit)
    suspend fun register(email: String, password: String, onSuccess: () -> Unit, onFailure: () -> Unit)
}