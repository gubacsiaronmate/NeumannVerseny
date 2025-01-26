package com.debdevs

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.jetbrains.exposed.sql.Database

suspend fun configureDatabases(dbUsername: String, dbPassword: String) = withContext(Dispatchers.IO) {
    Database.connect(
        url = "jdbc:postgresql://localhost:5432/postgres",
        driver = "org.postgresql.Driver",
        user = dbUsername,
        password = dbPassword,
    )
}