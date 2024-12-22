package com.debdevs

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.jetbrains.exposed.sql.Database

suspend fun configureDatabases(dbUsername: String, dbPassword: String) = withContext(Dispatchers.IO) {
    Database.connect(
        url = "jdbc:postgresql://dpg-ctb1fr23esus739e52g0-a.frankfurt-postgres.render.com:5432/versenydata",
        driver = "org.postgresql.Driver",
        user = dbUsername,
        password = dbPassword,
    )
}