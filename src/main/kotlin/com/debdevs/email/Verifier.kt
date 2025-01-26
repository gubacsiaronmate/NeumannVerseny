package com.debdevs.email

import java.util.regex.Pattern.compile

class Verifier(private val email: String) {
    fun isEmailValid(): Boolean {
        val emailRegex = compile(
            "[a-zA-Z0-9+._%\\-]{1,256}" + "@" +
                    "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
                    "(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"
        )
        return emailRegex.matcher(email).matches() && email.isNotBlank()
    }
}