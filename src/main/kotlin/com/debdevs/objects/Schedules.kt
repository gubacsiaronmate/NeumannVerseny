package com.debdevs.objects

import kotlinx.datetime.Clock
import kotlinx.datetime.TimeZone
import kotlinx.datetime.todayIn
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.kotlin.datetime.date

object Schedules : Table("Schedules") {
    val id = integer("id").uniqueIndex().autoIncrement()
    val userId = integer("userId").uniqueIndex().references(Users.id)
    val name = varchar("name", 255).default("Unnamed schedule $id")
    val createdAt = date("createdAt").default(Clock.System.todayIn(TimeZone.currentSystemDefault()))

    override val primaryKey = PrimaryKey(id)
}