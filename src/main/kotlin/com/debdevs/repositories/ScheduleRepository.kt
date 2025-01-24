package com.debdevs.repositories

import com.debdevs.data.Schedule
import com.debdevs.objects.Schedules
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction
import org.jetbrains.exposed.sql.update

/**
 * Retrieves all schedules from the database.
 *
 * @return A list of `Schedule` objects representing all schedules.
 */
suspend fun getAllSchedules(): List<Schedule> = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val schedules = Schedules.selectAll()
        return@transaction schedules.map {
            Schedule(
                id = it[Schedules.id],
                userId = it[Schedules.userId],
                name = it[Schedules.name],
                createdAt = it[Schedules.createdAt]
            )
        }
    }
}

/**
 * Retrieves a specific schedule by its ID.
 *
 * @param id The ID of the schedule to retrieve.
 * @return A `Schedule` object if found, or `null` if no schedule with the given ID exists.
 */
suspend fun getScheduleById(id: Int): Schedule? = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val schedule = Schedules.selectAll().firstOrNull { it[Schedules.id] == id }
        return@transaction schedule?.let {
            Schedule(
                id = it[Schedules.id],
                userId = it[Schedules.userId],
                name = it[Schedules.name],
                createdAt = it[Schedules.createdAt]
            )
        }
    }
}

/**
 * Adds a new schedule to the database.
 *
 * @param schedule The `Schedule` object to be added.
 * @return `true` if the schedule is successfully added, `false` otherwise.
 */
suspend fun addSchedule(schedule: Schedule): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val id = Schedules.insert {
            if (schedule.id != null) it[id] = schedule.id
            it[userId] = schedule.userId
            if (schedule.name != null) it[name] = schedule.name
            if (schedule.createdAt != null) it[createdAt] = schedule.createdAt
        } get Schedules.id

        return@transaction Schedules.selectAll().firstOrNull { it[Schedules.id] == id } != null
    }
}

/**
 * Deletes a schedule from the database by its ID.
 *
 * @param id The ID of the schedule to delete.
 * @return `true` if the schedule is successfully deleted, `false` otherwise.
 */
suspend fun deleteSchedule(id: Int): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val deleted = Schedules.deleteWhere(limit = 1) { Schedules.id eq id }
        return@transaction deleted == 1
    }
}

/**
 * Updates the details of an existing schedule in the database.
 *
 * @param schedule The `Schedule` object containing updated details.
 * @return `true` if the schedule is successfully updated, `false` otherwise.
 */
suspend fun updateSchedule(schedule: Schedule): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val updated = Schedules.update({ Schedules.id eq schedule.id!! }, limit = 1) {
            if (schedule.id != null) it[id] = schedule.id
            it[userId] = schedule.userId
            if (schedule.name != null) it[name] = schedule.name
            if (schedule.createdAt != null) it[createdAt] = schedule.createdAt
        }
        
        return@transaction updated == 1
    }
}