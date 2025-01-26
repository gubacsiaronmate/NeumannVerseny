package com.debdevs

import io.ktor.server.application.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureRouting() {
    routing {
        get("/") {
            call.respondText("""
                <!DOCTYPE html>
                <html>
                    <head>
                        <title>Hello from Ktor!</title>
                    </head>
                    <body style="background: black; color: white;">
                        <h1>Hello from Ktor!</h1>
                    </body>
                </html>
            """.trimIndent(), contentType = io.ktor.http.ContentType.Text.Html)
        }
    }
}
