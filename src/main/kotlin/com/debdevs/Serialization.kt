package com.debdevs

import com.debdevs.data.Schedule
import com.debdevs.data.ScheduleEntry
import com.debdevs.data.User
import com.debdevs.repositories.*
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

fun Application.configureSerialization() {
    install(ContentNegotiation) {
        json()
    }
    routing {
        get("/json/kotlinx-serialization") {
            call.respond(mapOf("hello" to "world"))
        }

        route("/DebDevsWebServices/api/NeumannVerseny") {
            route("/users") {
                route("/get") {
                    get("/all") {
                        val users = getAllUsers()
                        call.respond(
                            status = HttpStatusCode.OK,
                            users.ifEmpty { HttpStatusCode.NotFound }
                        )
                    }

                    get("/id/{id}") {
                        val id = call.parameters["id"]?.toIntOrNull()
                            ?: return@get call.respondText(
                                "Missing or malformed id",
                                status = HttpStatusCode.BadRequest
                            )
                        val user = getUserById(id)
                        call.respond(
                            status = HttpStatusCode.OK,
                            user ?: HttpStatusCode.NotFound
                        )
                    }
                }

                delete("/delete/id/{id}") {
                    val id = call.parameters["id"]?.toIntOrNull()
                        ?: return@delete call.respondText(
                            "Missing or malformed id",
                            status = HttpStatusCode.BadRequest
                        )
                    val isDeleted = deleteUser(id)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isDeleted) "User deleted"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/update") {
                    val user = call.receive<User>()
                    val isUpdated = updateUser(user)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isUpdated) "User updated"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/add") {
                    val user = call.receive<User>()
                    val isAdded = addUser(user)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isAdded) "User added"
                        else HttpStatusCode.NotModified
                    )
                }
            }

            route("/schedules") {
                route("/get") {
                    get("/all") {
                        val schedules = getAllSchedules()
                        call.respond(status = HttpStatusCode.OK, schedules.ifEmpty { HttpStatusCode.NotFound })
                    }

                    get("/id/{id}") {
                        val id = call.parameters["id"]?.toIntOrNull()
                            ?: return@get call.respondText(
                                "Missing or malformed id",
                                status = HttpStatusCode.BadRequest
                            )
                        val schedule = getScheduleById(id)
                        call.respond(status = HttpStatusCode.OK, schedule ?: HttpStatusCode.NotFound)
                    }
                }

                delete("/delete/id/{id}") {
                    val id = call.parameters["id"]?.toIntOrNull()
                        ?: return@delete call.respondText(
                            "Missing or malformed id",
                            status = HttpStatusCode.BadRequest
                        )
                    val isDeleted = deleteSchedule(id)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isDeleted) "Schedule deleted"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/update") {
                    val schedule = call.receive<Schedule>()
                    val isUpdated = updateSchedule(schedule)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isUpdated) "Schedule updated"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/add") {
                    val schedule = call.receive<Schedule>()
                    val isAdded = addSchedule(schedule)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isAdded) "Schedule added"
                        else HttpStatusCode.NotModified
                    )
                }
            }

            route("/schedule-entries") {
                route("/get") {
                    get("/all") {
                        val scheduleEntries = getAllScheduleEntries()
                        call.respond(status = HttpStatusCode.OK, scheduleEntries.ifEmpty { HttpStatusCode.NotFound })
                    }

                    get("/id/{id}") {
                        val id = call.parameters["id"]?.toIntOrNull()
                            ?: return@get call.respondText(
                                "Missing or invalid id",
                                status = HttpStatusCode.BadRequest
                            )
                        val scheduleEntry = getScheduleEntryById(id)
                        call.respond(status = HttpStatusCode.OK, scheduleEntry ?: HttpStatusCode.NotFound)
                    }
                }

                delete("/delete/id/{id}") {
                    val id = call.parameters["id"]?.toIntOrNull()
                        ?: return@delete call.respondText(
                            "Missing or invalid id",
                            status = HttpStatusCode.BadRequest
                        )
                    val isDeleted = deleteScheduleEntry(id)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isDeleted) "Schedule entry deleted"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/update") {
                    val scheduleEntry = call.receive<ScheduleEntry>()
                    val isUpdated = updateScheduleEntry(scheduleEntry)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isUpdated) "Schedule entry updated"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/add") {
                    val scheduleEntry = call.receive<ScheduleEntry>()
                    val isAdded = addScheduleEntry(scheduleEntry)
                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isAdded) "Schedule entry added"
                        else HttpStatusCode.NotModified
                    )
                }
            }
        }
    }
}
