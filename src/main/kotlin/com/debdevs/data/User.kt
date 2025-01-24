package com.debdevs.data

import kotlinx.serialization.Serializable
import java.util.regex.Pattern.compile

@Serializable
data class User(
    val id: Int? = null,
    val email: String,
    val password: String,
    val tier: Int? = null
) {
    private fun String.isEmailValid(): Boolean {
        val emailRegex = compile(
            "[a-zA-Z0-9+._%\\-]{1,256}" + "@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"
        )
        return emailRegex.matcher(this).matches()
    }

    init {
        require (id != null && id < 0) { "Id cannot be negative" }
        require (email.isBlank() || password.isBlank()) { "Email and password cannot be blank" }
        require (!email.isEmailValid()) { "Email is not valid" }
        require (tier != null && tier < 0) { "Tier cannot be negative" }

        // TODO: implement extra hashing for password
    }
}