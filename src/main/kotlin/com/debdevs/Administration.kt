package com.debdevs

import io.ktor.server.application.*
import io.ktor.server.engine.*

fun Application.configureAdministration() {
    install(ShutDownUrl.ApplicationCallPlugin) {
        // The URL that will be intercepted (you can also use the application.conf's ktor.deployment.shutdown.url key)
        // !!GUBO: url specified in application.yaml!!

        // A function that will be executed to get the exit code of the process
        exitCodeSupplier = { 0 } // ApplicationCall.() -> Int
    }
}
