package com.debdevs.project

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform