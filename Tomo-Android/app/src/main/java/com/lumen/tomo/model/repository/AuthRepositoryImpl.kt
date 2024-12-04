package com.lumen.tomo.model.repository

import android.content.Context
import android.util.Log
import com.lumen.tomo.util.DataStoreHelper
import io.github.jan.supabase.SupabaseClient
import io.github.jan.supabase.gotrue.auth
import io.github.jan.supabase.gotrue.providers.builtin.Email
import javax.inject.Inject

class AuthRepositoryImpl @Inject constructor(
    private val client: SupabaseClient,
    private val dataStoreHelper: DataStoreHelper
) : AuthRepository {

    override suspend fun logIn(email: String, password: String, onSuccess: () -> Unit, onFailure: (Exception) -> Unit) {
        try {
            val session = client.auth.signInWith(Email) {
                this.email = email
                this.password = password
            }
            client.auth.currentSessionOrNull()?.refreshToken?.let {
                dataStoreHelper.saveTokens(client.auth.currentAccessTokenOrNull().toString(),
                    it
                )
            }
            onSuccess()
        } catch (e: Exception) {
            onFailure(e)
        }
    }

    override suspend fun register(email: String, password: String, onSuccess: () -> Unit, onFailure: (Exception) -> Unit) {
        try {
            val session = client.auth.signUpWith(Email) {
                this.email = email
                this.password = password
            }
            client.auth.currentSessionOrNull()?.refreshToken?.let {
                dataStoreHelper.saveTokens(client.auth.currentAccessTokenOrNull().toString(),
                    it
                )
            }
            onSuccess()
        } catch (e: Exception) {
            onFailure(e)
        }
    }

    override suspend fun logOut() {
        client.auth.signOut()
        dataStoreHelper.clearTokens()
    }

    override suspend fun refreshTokenIfNeeded() {
        val currentAccessToken = dataStoreHelper.getAccessToken()
        val currentRefreshToken = dataStoreHelper.getRefreshToken()

        // Check if access token needs to be refreshed
        if ((client.auth.currentSessionOrNull()?.expiresIn ?: 0) < 300) { // Less than 5 minutes remaining
            try {
                val session = client.auth.refreshSession(currentRefreshToken ?: throw IllegalStateException("Refresh token is null"))
                dataStoreHelper.saveTokens(session.accessToken, session.refreshToken)
            } catch (e: Exception) {
                // Handle token refresh failure
                throw IllegalStateException("Token refresh failed", e)
            }
        }
    }
}