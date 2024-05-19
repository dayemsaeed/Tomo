package com.lumen.tomo.model.repository

import android.content.Context
import android.util.Log
import com.lumen.tomo.util.DataStoreHelper
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.gotrue.auth
import io.github.jan.supabase.gotrue.providers.builtin.Email
import javax.inject.Inject

class AuthRepositoryImpl @Inject constructor(
    private val client: SupabaseClient
): AuthRepository {

    override suspend fun logIn(email: String, password: String, onSuccess: () -> Unit, onFailure: (Exception) -> Unit) {
        try {
            client.auth.signInWith(Email) {
                this.email = email
                this.password = password
            }
            onSuccess()
        } catch (e: Exception) {
            onFailure(e)
        }
    }

    override suspend fun register(email: String, password: String, onSuccess: () -> Unit, onFailure: (Exception) -> Unit) {
        try {
            client.auth.signUpWith(Email) {
                this.email = email
                this.password = password
            }
            onSuccess()
        } catch (e: Exception) {
            onFailure(e)
        }
    }

    override suspend fun logOut() {
        client.auth.signOut()
    }
}