package com.debdevs.objects

import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.kotlin.datetime.time

object ScheduleEntries : Table("schedule_entries") {
    val id = integer("id").uniqueIndex().autoIncrement()
    val scheduleId = integer("schedule_id").uniqueIndex().references(Schedules.id)
    val startTime = time("start_time")
    val endTime = time("end_time")
    val title = varchar("title", 255).default("Unnamed event")
    val description = text("description").nullable()

    override val primaryKey = PrimaryKey(id)
}