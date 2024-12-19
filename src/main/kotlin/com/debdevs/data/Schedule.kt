package com.debdevs.data

import kotlinx.datetime.LocalDate

data class Schedule(
    val id: Int?,
    val userId: Int,
    val name: String,
    val createdAt: LocalDate
)
