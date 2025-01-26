package com.debdevs.email

import java.util.*
import javax.mail.AuthenticationFailedException
import javax.mail.Authenticator
import javax.mail.Session
import javax.mail.Transport
import javax.mail.internet.InternetAddress
import javax.mail.internet.MimeMessage

class EmailService(
    val fromEmail: String,
    private val password: String
) {
    private val properties = Properties().apply {
        put("mail.smtp.host", "smtp.gmail.com")
        put("mail.smtp.port", "587")
        put("mail.smtp.auth", "true")
        put("mail.smtp.starttls.enable", "true")
    }

    private val session = Session.getDefaultInstance(properties, object : Authenticator() {
        override fun getPasswordAuthentication(): javax.mail.PasswordAuthentication {
            return javax.mail.PasswordAuthentication(fromEmail, password)
        }
    }) ?: throw AuthenticationFailedException("Authentication failed")

    /**
     * Sends an email message using the configured mail session and properties.
     *
     * @return A boolean value indicating whether the email was sent successfully.
     * Returns `true` if the email was sent successfully, or `false` if an error occurred.
     */
    fun send(
        to: String,
        subjectText: String,
        body: String,
        isHtml: Boolean = true,
    ): Boolean {
        return try {
            val message = MimeMessage(session).apply {
                setFrom(InternetAddress(fromEmail))
                setRecipients(javax.mail.Message.RecipientType.TO, to)
                subject = subjectText
                setContent(
                    body,
                    if (isHtml) "text/html; charset=utf-8"
                    else "text/plain; charset=utf-8"
                )
            }

            Transport.send(message)
            println("Email sent successfully!")
            true
        } catch (e: Exception) {
            e.printStackTrace()
            println("Failed to send email: ${e.localizedMessage}")
            false
        }
    }
}