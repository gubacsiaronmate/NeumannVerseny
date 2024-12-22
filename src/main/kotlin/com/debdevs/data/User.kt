package com.debdevs.data

import kotlinx.serialization.Serializable

@Serializable
data class User(
    val id: Int?,
    val email: String,
    val password: String,
    val tier: Int?
)