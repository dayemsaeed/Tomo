package com.lumen.tomo.model.service

import com.lumen.tomo.BuildConfig
import com.lumen.tomo.model.llmreponse.BreakdownResponse
import com.lumen.tomo.model.llmreponse.TaskRequest
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface TaskService {
    @POST(BuildConfig.BREAKDOWN_URI)
    suspend fun breakdownTask(@Body taskInformation: TaskRequest): Response<BreakdownResponse>
}