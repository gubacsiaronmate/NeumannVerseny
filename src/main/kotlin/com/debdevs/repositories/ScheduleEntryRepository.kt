package com.debdevs.repositories

import com.debdevs.data.ScheduleEntry
import com.debdevs.objects.ScheduleEntries
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction
import org.jetbrains.exposed.sql.update

/**
 * Retrieves all schedule entries from the database.
 *
 * @return a list of [ScheduleEntry] containing all entries from the schedule table.
 */
suspend fun getAllScheduleEntries(): List<ScheduleEntry> = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val scheduleEntries = ScheduleEntries.selectAll()
        return@transaction scheduleEntries.map {
            ScheduleEntry(
                id = it[ScheduleEntries.id],
                scheduleId = it[ScheduleEntries.scheduleId],
                startTime = it[ScheduleEntries.startTime],
                endTime = it[ScheduleEntries.endTime],
                title = it[ScheduleEntries.title],
                description = it[ScheduleEntries.description],
            )
        }
    }
}

/**
 * Retrieves a specific schedule entry by its ID.
 *
 * @param id the unique ID of the schedule entry to retrieve.
 * @return the [ScheduleEntry] if found, or null otherwise.
 */
suspend fun getScheduleEntryById(id: Int): ScheduleEntry? = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val scheduleEntry = ScheduleEntries.selectAll().firstOrNull { it[ScheduleEntries.id] == id }
        return@transaction scheduleEntry?.let {
            ScheduleEntry(
                id = it[ScheduleEntries.id],
                scheduleId = it[ScheduleEntries.scheduleId],
                startTime = it[ScheduleEntries.startTime],
                endTime = it[ScheduleEntries.endTime],
                title = it[ScheduleEntries.title],
                description = it[ScheduleEntries.description],
            )
        }
    }
}

/**
 * Adds a new schedule entry to the database.
 *
 * @param scheduleEntry the [ScheduleEntry] object containing the data to insert.
 * @return true if the entry is successfully added, false otherwise.
 */
suspend fun addScheduleEntry(scheduleEntry: ScheduleEntry): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val id = ScheduleEntries.insert {
            if (scheduleEntry.id != null) it[id] = scheduleEntry.id
            it[scheduleId] = scheduleEntry.scheduleId
            it[startTime] = scheduleEntry.startTime
            it[endTime] = scheduleEntry.endTime
            if (scheduleEntry.title != null) it[title] = scheduleEntry.title
            it[description] = scheduleEntry.description
        } get ScheduleEntries.id

        return@transaction ScheduleEntries.selectAll().firstOrNull { it[ScheduleEntries.id] == id } != null
    }
}

/**
 * Deletes a schedule entry by its ID.
 *
 * @param id the unique ID of the schedule entry to delete.
 * @return true if the entry is successfully deleted, false otherwise.
 */
suspend fun deleteScheduleEntry(id: Int): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val deleted = ScheduleEntries.deleteWhere { ScheduleEntries.id eq id }
        return@transaction deleted == 1
    }
}

/**
 * Modifies an existing schedule entry in the database.
 *
 * @param scheduleEntry the [ScheduleEntry] containing updated data.
 * @return true if the entry is successfully modified, false otherwise.
 */
suspend fun updateScheduleEntry(scheduleEntry: ScheduleEntry): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val updated = ScheduleEntries.update({ ScheduleEntries.id eq scheduleEntry.id!! }) {
            if (scheduleEntry.id != null) it[id] = scheduleEntry.id
            it[scheduleId] = scheduleEntry.scheduleId
            it[startTime] = scheduleEntry.startTime
            it[endTime] = scheduleEntry.endTime
            if (scheduleEntry.title != null) it[title] = scheduleEntry.title
            it[description] = scheduleEntry.description
        }

        return@transaction updated == 1
    }
}