import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android") version "2.3.21"
}

group = "com.jrai.flutter_keyboard_visibility"
version = "1.0"

repositories {
        google()
        mavenCentral()
    }

android {
    namespace = "com.jrai.flutter_keyboard_visibility"
    compileSdk = 37

    defaultConfig {
        minSdk 24
    }

    lint {
        disable 'InvalidPackage'
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_21
        targetCompatibility JavaVersion.VERSION_21
    }
}
