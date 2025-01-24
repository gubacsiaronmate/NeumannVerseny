package com.debdevs

import io.ktor.server.application.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking

fun main(args: Array<String>) {
    io.ktor.server.netty.EngineMain.main(args)
}

fun Application.module() = runBlocking {
    val dbUsername = environment.config.propertyOrNull("ktor.database.db_user")?.getString()
    val dbPassword = environment.config.propertyOrNull("ktor.database.db_password")?.getString()
    configureSecurity()
    configureHTTP()
    configureMonitoring()
    configureSerialization()
    println("Databases.kt:\n\tdbUsername: $dbUsername\n\tdbPassword: $dbPassword")
    if (dbUsername != null && dbPassword != null) async(Dispatchers.Default) { configureDatabases(dbUsername, dbPassword) }.await()
    else throw Exception("Database credentials not found in environment variables")
    configureSockets()
    configureAdministration()
    configureRouting()
}
