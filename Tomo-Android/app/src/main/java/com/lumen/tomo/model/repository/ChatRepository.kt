package com.lumen.tomo.model.repository

interface ChatRepository {
    suspend fun sendChat(message: String)
    suspend fun getResponse(response: String)
}