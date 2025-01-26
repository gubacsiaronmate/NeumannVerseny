package com.debdevs

import com.debdevs.data.Schedule
import com.debdevs.data.ScheduleEntry
import com.debdevs.data.User
import com.debdevs.email.EmailService
import com.debdevs.email.OTPGenerator
import com.debdevs.repositories.*
import com.debdevs.security.verifyPassword
import io.ktor.http.*
import io.ktor.serialization.kotlinx.json.*
import io.ktor.server.application.*
import io.ktor.server.plugins.contentnegotiation.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*

typealias Email = String

fun Application.configureSerialization() {
    install(ContentNegotiation) {
        json()
    }
    routing {
        get("/json/kotlinx-serialization") {
            call.respond(mapOf("hello" to "world"))
        }

        route("/DebDevsWebServices/api/NeumannVerseny") {
            val emailService = EmailService(
                environment.config.property("ktor.email.host").getString(),
                environment.config.property("ktor.email.email_pwd").getString()
            )

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
                    val user: User

                    try { user = call.receive<User>() }
                    catch (e: Exception) {
                        return@post call.respondText(
                            e.message ?: "Could not receive User",
                            status = HttpStatusCode.BadRequest
                        )
                    }

                    val isUpdated = updateUser(user)

                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isUpdated) "User updated"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/add") {
                    val user: User

                    try { user = call.receive<User>() }
                    catch (e: Exception) {
                        return@post call.respondText(
                            e.message ?: "Could not receive User",
                            status = HttpStatusCode.BadRequest
                        )
                    }

                    call.respond(
                        status = HttpStatusCode.OK,
                        if (
                            getUserById(addUser(user)) != null
                        ) "User added"
                        else HttpStatusCode.NotModified
                    )
                }
            }

            route("/schedules") {
                route("/get") {
                    get("/all") {
                        val schedules = getAllSchedules()

                        call.respond(
                            status = HttpStatusCode.OK,
                            schedules.ifEmpty
                            { HttpStatusCode.NotFound }
                        )
                    }

                    get("/id/{id}") {
                        val id = call.parameters["id"]?.toIntOrNull()
                            ?: return@get call.respondText(
                                "Missing or malformed id",
                                status = HttpStatusCode.BadRequest
                            )

                        val schedule = getScheduleById(id)

                        call.respond(
                            status = HttpStatusCode.OK,
                            schedule ?: HttpStatusCode.NotFound
                        )
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
                    val schedule: Schedule

                    try { schedule = call.receive<Schedule>() }
                    catch (e: Exception) {
                        return@post call.respondText(
                            e.message ?: "Could not receive Schedule",
                            status = HttpStatusCode.BadRequest
                        )
                    }

                    val isUpdated = updateSchedule(schedule)

                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isUpdated) "Schedule updated"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/add") {
                    val schedule: Schedule

                    try { schedule = call.receive<Schedule>() }
                    catch (e: Exception) {
                        return@post call.respondText(
                            e.message ?: "Could not receive Schedule",
                            status = HttpStatusCode.BadRequest
                        )
                    }
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

                        call.respond(
                            status = HttpStatusCode.OK,
                            scheduleEntries.ifEmpty
                            { HttpStatusCode.NotFound }
                        )
                    }

                    get("/id/{id}") {
                        val id = call.parameters["id"]?.toIntOrNull()
                            ?: return@get call.respondText(
                                "Missing or invalid id",
                                status = HttpStatusCode.BadRequest
                            )

                        val scheduleEntry = getScheduleEntryById(id)

                        call.respond(
                            status = HttpStatusCode.OK,
                            scheduleEntry ?: HttpStatusCode.NotFound
                        )
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
                    val scheduleEntry: ScheduleEntry

                    try { scheduleEntry = call.receive<ScheduleEntry>() }
                    catch (e: Exception) {
                        return@post call.respondText(
                            e.message ?: "Could not receive Schedule Entry",
                            status = HttpStatusCode.BadRequest
                        )
                    }

                    val isUpdated = updateScheduleEntry(scheduleEntry)

                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isUpdated) "Schedule entry updated"
                        else HttpStatusCode.NotModified
                    )
                }

                post("/add") {
                    val scheduleEntry: ScheduleEntry

                    try { scheduleEntry = call.receive<ScheduleEntry>() }
                    catch (e: Exception) {
                        return@post call.respondText(
                            e.message ?: "Could not receive Schedule Entry",
                            status = HttpStatusCode.BadRequest
                        )
                    }

                    val isAdded = addScheduleEntry(scheduleEntry)

                    call.respond(
                        status = HttpStatusCode.OK,
                        if (isAdded) "Schedule entry added"
                        else HttpStatusCode.NotModified
                    )
                }
            }

            /*
            * 1. not done: /                    - what would this serve?
            * 2.     done: /login
            * 3. not done: /home                - yet to decide what goes on the home page
            * 4.     done: /signup
            * 5.     done: /forgetpassword
            * 6. not done: /newpassword         - gets covered by `/forgetpassword`
            * 7. not done: /otpverification     - gets covered by the solution of every other email related endpoint
            * 8. not done: /passwordchanges     - can't understand this
            * */

            post("/login") {
                val user: User

                try { user = call.receive<User>() }
                catch (e: Exception) {
                    return@post call.respondText(
                        e.message ?: "Could not receive User",
                        status = HttpStatusCode.BadRequest
                    )
                }

                val storedUser = getUserByEmail(user.email)

                call.respond(
                    status = HttpStatusCode.OK,
                    if (
                        storedUser != null &&
                        verifyPassword(
                            user.password,
                            storedUser.password
                        )) storedUser
                    else HttpStatusCode.Unauthorized
                )
            }

            post("/signup") {
                val user: User

                try { user = call.receive<User>() }
                catch (e: Exception) {
                    return@post call.respondText(
                        e.message ?: "Could not receive User",
                        status = HttpStatusCode.BadRequest
                    )
                }

                val otpGeneratorContent = OTPGenerator().getVerificationEmailContent()

                val isEmailSent = emailService.send(
                    user.email,
                    "OnTime Email Verification",
                    otpGeneratorContent.email
                )

                if (!isEmailSent) return@post call.respond(
                    status = HttpStatusCode.InternalServerError,
                    "Could not send email"
                )

                post("/{code}") {
                    @Suppress("LABEL_NAME_CLASH")
                    val code = call.parameters["code"]?.toIntOrNull()
                        ?: return@post call.respondText(
                            "Missing or invalid code",
                            status = HttpStatusCode.BadRequest
                        )
                    if (code == otpGeneratorContent.otp) {
                        val id = addUser(user)
                        call.respond(
                            status = HttpStatusCode.OK,
                            getUserById(id) ?: HttpStatusCode.Unauthorized
                        )
                    }
                }
            }

            post("/forgetpassword") {
                val email: Email

                try {
                    email = call.receive<Email>()

                }
                catch (e: Exception) {
                    return@post call.respondText(
                        e.message ?: "Could not receive User",
                        status = HttpStatusCode.BadRequest
                    )
                }

                val otpGeneratorContent = OTPGenerator().getVerificationEmailContent()

                val isEmailSent = emailService.send(
                    email,
                    "OnTime Email Verification",
                    otpGeneratorContent.email
                )

                if (!isEmailSent) return@post call.respond(
                    status = HttpStatusCode.InternalServerError,
                    "Could not send email"
                )

                post("/{code}") {
                    @Suppress("LABEL_NAME_CLASH")
                    val code = call.parameters["code"]?.toIntOrNull()
                        ?: return@post call.respondText(
                            "Missing or invalid code",
                            status = HttpStatusCode.BadRequest
                        )

                    @Suppress("LABEL_NAME_CLASH")
                    if (code != otpGeneratorContent.otp) return@post call.respond(
                        status = HttpStatusCode.Unauthorized,
                        "Invalid code"
                    )

                    post("/newpassword") {
                        val newUser: User
                        try { newUser = call.receive<User>() }
                        catch (e: Exception) {
                            @Suppress("LABEL_NAME_CLASH")
                            return@post call.respondText(
                                e.message ?: "Could not receive User",
                                status = HttpStatusCode.BadRequest
                            )
                        }

                        @Suppress("LABEL_NAME_CLASH") val storedUser =
                            if (newUser.id != null) getUserById(newUser.id)
                                ?: return@post call.respond(
                                    status = HttpStatusCode.InternalServerError,
                                    "User not found"
                                )
                            else getUserByEmail(email)
                                ?: return@post call.respond(
                                    status = HttpStatusCode.InternalServerError,
                                    "User not found"
                                )
                        storedUser.password = newUser.password
                        call.respond(
                            status = HttpStatusCode.OK,
                            if (updateUser(storedUser))
                                "Password changed successfully"
                            else HttpStatusCode.NotModified
                        )
                    }
                }
            }
        }
    }
}
