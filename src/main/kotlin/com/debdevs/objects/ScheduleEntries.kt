package com.debdevs.objects

import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.kotlin.datetime.time

object ScheduleEntries : Table("ScheduleEntries") {
    val id = integer("id").uniqueIndex().autoIncrement()
    val scheduleId = integer("scheduleId").uniqueIndex().references(Schedules.id)
    val startTime = time("startTime")
    val endTime = time("endTime")
    val title = varchar("title", 255).default("Unnamed event")
    val description = text("description").nullable()

    override val primaryKey = PrimaryKey(id)
}