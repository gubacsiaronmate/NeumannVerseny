package com.debdevs

import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    routing {
        get("/test-page") {
            call.respondText("Hello World!")
        }
    }
}
