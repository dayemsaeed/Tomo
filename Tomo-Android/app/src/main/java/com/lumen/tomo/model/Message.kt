package com.lumen.tomo.model

import java.util.UUID

data class Message(val id: UUID, val message: String, val isSender: Boolean)