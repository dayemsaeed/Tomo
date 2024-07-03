package com.lumen.tomo.model

import java.time.LocalDateTime

data class User(
    val id: Int,
    val username: String,
    val email: String,
    val profilePictureUrl: String,
    val createdAt: LocalDateTime
)
