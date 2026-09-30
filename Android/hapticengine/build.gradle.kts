plugins {
    alias(libs.plugins.android.library)
}

android {
    namespace = "dev.codepassion.hapticengine"
    compileSdk {
        version = release(36) { minorApiLevel = 1 }
    }

    defaultConfig {
        // VibrationEffect with per-step amplitudes requires API 26.
        minSdk = 26
        consumerProguardFiles("consumer-rules.pro")
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

kotlin {
    explicitApi()
}

dependencies {
    implementation(libs.androidx.annotation)
    testImplementation(libs.junit)
}
