package com.debdevs.data

import com.debdevs.email.Verifier
import com.debdevs.security.hashPassword
import kotlinx.serialization.Required
import kotlinx.serialization.Serializable

@Serializable
data class User(
    val id: Int? = null,
    @Required val email: String,
    private var _password : String,
    val tier: Int? = null
) {
    @Required var password: String
        get() = _password
        set(value) { _password = hashPassword(value) }

    init {
        require (id != null && id < 0) { "Id cannot be negative" }
        require (password.isNotBlank()) { "Email and password cannot be blank" }
        require (!Verifier(email).isEmailValid()) { "Email is not valid" }
        require (tier != null && tier < 0) { "Tier cannot be negative" }
    }
}