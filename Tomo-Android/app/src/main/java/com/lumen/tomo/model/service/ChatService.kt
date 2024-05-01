package com.lumen.tomo.model.service

import com.lumen.tomo.BuildConfig
import com.lumen.tomo.model.GPTResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST

interface ChatService {
    @Headers(
        "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y21laHJtbW5zdHFyb3Z3YWJ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTEyMjk3MzgsImV4cCI6MjAyNjgwNTczOH0.8UcMGluU4HlJqklHzMRn2aBjDQskr0mvY3c2b7w0PTs",
        "Content-Type: application/json"
    )
    @POST(BuildConfig.BOT_URI)
    suspend fun generateText(@Body messages: Map<String, Any>): Response<GPTResponse>
}