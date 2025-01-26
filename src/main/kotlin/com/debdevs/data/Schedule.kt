package com.debdevs.data

import kotlinx.datetime.LocalDate
import kotlinx.serialization.Required
import kotlinx.serialization.Serializable
import java.util.regex.Pattern.compile

@Serializable
data class Schedule(
    val id: Int? = null,
    @Required val userId: Int,
    val name: String? = null,
    val createdAt: LocalDate? = null
) {
    init {
        val dateRegex = compile("^([0-9]{4})-([0-9]{2})-([0-9]{2})$")

        require(id != null && id < 0) { "Id cannot be negative" }
        require(userId < 0) { "UserId cannot be negative" }
        if (createdAt != null)
            require(dateRegex.matcher(createdAt.toString()).matches())
            { "Created at must be in the format YYYY-MM-DD" }
    }
}
