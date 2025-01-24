package com.debdevs.objects

import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.kotlin.datetime.date

object Schedules : Table("schedules") {
    val id = integer("id").uniqueIndex().autoIncrement()
    val userId = integer("user_id").uniqueIndex().references(Users.id)
    val name = varchar("name", 255).default("Unnamed schedule $id")
    val createdAt = date("createdAt")

    override val primaryKey = PrimaryKey(id)
}