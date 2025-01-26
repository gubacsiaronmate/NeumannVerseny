package com.debdevs.repositories

import com.debdevs.data.User
import com.debdevs.objects.Users
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.jetbrains.exposed.sql.SqlExpressionBuilder.eq
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.selectAll
import org.jetbrains.exposed.sql.transactions.transaction
import org.jetbrains.exposed.sql.update

/**
 * Retrieves all users from the database.
 *
 * @return A list containing all users present in the database.
 */
suspend fun getAllUsers(): List<User> = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val users = Users.selectAll()
        return@transaction users.map {
            User(
                id = it[Users.id],
                email = it[Users.email],
                _password = it[Users.password],
                tier = it[Users.tier]
            )
        }
    }
}

/**
 * Retrieves a user from the database by their ID.
 *
 * @param id The unique identifier of the user.
 * @return The user associated with the given ID, or `null` if no user exists.
 */
suspend fun getUserById(id: Int): User? = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val user = Users.selectAll().firstOrNull { it[Users.id] == id }
        return@transaction user?.let {
            User(
                id = it[Users.id],
                email = it[Users.email],
                _password = it[Users.password],
                tier = it[Users.tier]
            )
        }
    }
}

/**
 * Adds a new user to the database.
 *
 * @param user The user object to be added to the database.
 * @return `true` if the user was successfully added, `false` otherwise.
 */
suspend fun addUser(user: User): Int = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val id = Users.insert {
            if (user.id != null) it[id] = user.id
            it[email] = user.email
            it[password] = user.password
            if (user.tier != null) it[tier] = user.tier
        } get Users.id

        return@transaction id
    }
}

/**
 * Deletes a user from the database based on their ID.
 *
 * @param id The unique identifier of the user to be deleted.
 * @return `true` if the user was successfully deleted, `false` otherwise.
 */
suspend fun deleteUser(id: Int): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val deleted = Users.deleteWhere { Users.id eq id }
        return@transaction deleted == 1
    }
}

/**
 * Updates the details of an existing user in the database.
 *
 * @param user The user object containing the updated details.
 * @return `true` if the user was successfully updated, `false` otherwise.
 */
suspend fun updateUser(user: User): Boolean = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val updated = Users.update({ Users.id eq user.id!! }) {
            if (user.id != null) it[id] = user.id
            it[email] = user.email
            it[password] = user.password
            if (user.tier != null) it[tier] = user.tier
        }

        return@transaction updated == 1
    }
}

suspend fun getUserByEmail(email: String): User? = withContext(Dispatchers.IO) {
    return@withContext transaction {
        val user = Users.selectAll().firstOrNull { it[Users.email] == email }
        return@transaction user?.let {
            User(
                id = it[Users.id],
                email = it[Users.email],
                _password = it[Users.password],
                tier = it[Users.tier]
            )
        }
    }
}