package com.debdevs

import io.ktor.server.application.*

fun main(args: Array<String>) {
    io.ktor.server.netty.EngineMain.main(args)
}

fun Application.module() {
    val dbUsername = environment.config.propertyOrNull("ktor.database.db_user")?.getString()
    val dbPassword = environment.config.propertyOrNull("ktor.database.db_password")?.getString()
    configureSecurity()
    configureHTTP()
    configureMonitoring()
    configureSerialization()
    if (dbUsername != null && dbPassword != null) configureDatabases(dbUsername, dbPassword)
    else throw Exception("Database credentials not found in environment variables")
    configureSockets()
    configureAdministration()
    configureRouting()
}
