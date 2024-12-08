package com.debdevs

import org.jetbrains.exposed.sql.Database

fun configureDatabases() {
    Database.connect(
        url = "jdbc:postgresql://jbwl6nLKJ39Dvu7ekUaAFbGrzwJf4q1F@dpg-ctb1fr23esus739e52g0-a.frankfurt-postgres.render.com/versenydata",
        driver = "org.postgresql.Driver",
        user = System.getenv("NEUMANN_VERSENY_DATABASE_USERNAME"),
        password = System.getenv("NEUMANN_VERSENY_DATABASE_PASSWORD"),
    )
}
