package com.lumen.tomo.model.repositories

import android.util.Log
import com.google.firebase.auth.ktx.auth
import com.google.firebase.ktx.Firebase

class AuthRepository {

    private val auth = Firebase.auth

    fun logIn(email: String, password: String, onSuccess: () -> Unit, onFailure: (Exception) -> Unit) {
        auth.signInWithEmailAndPassword(email, password)
            .addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    Log.d(TAG_LOGIN, "logIn: Success")
                    onSuccess()
                } else {
                    Log.e(TAG_LOGIN, "logIn: Failed\nReason: ${task.exception?.message}")
                    onFailure(task.exception!!)
                }
            }
    }

    fun register(email: String, password: String, onSuccess: () -> Unit, onFailure: () -> Unit) {
        auth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener {task ->
                if (task.isSuccessful) {
                    Log.d(TAG_REGISTER, "register: Success")
                    onSuccess()
                } else {
                    Log.e(TAG_REGISTER, "register: Failed\nReason: ${task.exception?.message}")
                    onFailure()
                }
            }
    }

    fun logOut() {
        auth.signOut()
    }

    companion object {
        private const val TAG_LOGIN = "LoginFragment.kt"
        private const val TAG_REGISTER = "RegisterFragment.kt"
    }

}