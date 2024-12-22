package com.debdevs.data

import kotlinx.datetime.LocalDate
import kotlinx.serialization.Serializable

@Serializable
data class Schedule(
    val id: Int?,
    val userId: Int,
    val name: String,
    val createdAt: LocalDate
)
