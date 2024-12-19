package com.debdevs.data

import kotlinx.datetime.LocalTime

data class ScheduleEntry(
    val id: Int?,
    val scheduleId: Int,
    val startTime: LocalTime,
    val endTime: LocalTime,
    val title: String,
    val description: String?
)
