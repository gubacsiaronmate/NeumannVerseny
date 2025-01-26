package com.debdevs.security

import at.favre.lib.crypto.bcrypt.BCrypt

fun hashPassword(password: String): String {
    return BCrypt.withDefaults().hashToString(12, password.toCharArray())
}

fun verifyPassword(password: String, hashedPassword: String): Boolean {
    val result = BCrypt.verifyer().verify(password.toCharArray(), hashedPassword)
    return result.verified
}