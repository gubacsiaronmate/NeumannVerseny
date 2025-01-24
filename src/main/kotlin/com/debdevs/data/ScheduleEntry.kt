package com.debdevs.data

import kotlinx.datetime.LocalTime
import kotlinx.serialization.Serializable
import java.util.regex.Pattern.compile

@Serializable
data class ScheduleEntry(
    val id: Int? = null,
    val scheduleId: Int,
    val startTime: LocalTime,
    val endTime: LocalTime,
    val title: String? = null,
    val description: String? = null
) {
    init {
        val timeRegex = compile("^([01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$")

        require(id != null && id < 0) { "Id cannot be negative" }
        require(scheduleId < 0) { "ScheduleId cannot be negative" }
        require(timeRegex.matcher(startTime.toString()).matches())
        { "Start time must be in the format HH:mm:ss" }
        require(timeRegex.matcher(endTime.toString()).matches())
        { "End time must be in the format HH:mm:ss" }
        require(startTime < endTime)
    }
}