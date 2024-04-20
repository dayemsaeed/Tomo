package com.lumen.tomo.model.repository

import com.lumen.tomo.model.GPTResponse


interface ChatRepository {
    suspend fun fetchGeneratedText(messages: List<Map<String, String>>): Result<GPTResponse>
}