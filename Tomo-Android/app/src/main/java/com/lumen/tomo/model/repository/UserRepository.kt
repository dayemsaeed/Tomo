package com.lumen.tomo.model.repository

import com.google.firebase.auth.FirebaseUser

interface UserRepository {
    suspend fun addUserName(name: String)
    suspend fun getUserName(user: FirebaseUser)
}