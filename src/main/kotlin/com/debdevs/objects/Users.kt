package com.debdevs.objects

import org.jetbrains.exposed.sql.Table

object Users : Table("users") {
    val id = integer("id").uniqueIndex().autoIncrement()
    val email = varchar("email", 255)
    val password = varchar("password", 255)
    val tier = integer("tier").default(0).nullable()

    override val primaryKey = PrimaryKey(id)
}