package com.debdevs.email

// to use in shared code without imports
@Suppress("ACTUAL_WITHOUT_EXPECT") // internal expect is not matched with internal typealias to public type
internal typealias Serializable = java.io.Serializable

data class OTPContent(
    val otp: Int,
    val email: String
) : Serializable {

    /**
     * Returns string representation of the [OTPContent] including its [otp] and [email] values.
     */
    override fun toString(): String = "($otp, $email)"
}