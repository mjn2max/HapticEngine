import kotlinx.validation.KotlinApiBuildTask
import kotlinx.validation.KotlinApiCompareTask

plugins {
    alias(libs.plugins.android.library)
    // Provides the API dump and compare tasks registered below.
    alias(libs.plugins.kotlinx.binary.compatibility.validator)
    alias(libs.plugins.maven.publish)
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

        // Compiling against 36.1 would otherwise make every app compile against it too. The library
        // uses nothing newer than `VibrationAttributes`, from API 33.
        aarMetadata {
            minCompileSdk = 33
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
}

// Publishes the release variant with sources and javadoc jars, as Maven Central requires. Coordinates and POM
// details are in gradle.properties. The release workflow provides the Maven Central credentials and signing
// key as `ORG_GRADLE_PROJECT_*` environment variables; without a key, local publishing stays unsigned.
mavenPublishing {
    publishToMavenCentral(automaticRelease = false)
    if (providers.gradleProperty("signingInMemoryKey").isPresent) {
        signAllPublications()
    }
}

kotlin {
    explicitApi()

    // Built against an older Kotlin than the one compiling it, so apps still on Kotlin 2.1 can use it:
    // the POM then asks for stdlib 2.1 rather than the newest.
    coreLibrariesVersion = "2.1.21"

    compilerOptions {
        apiVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_2_1)
        languageVersion.set(org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_2_1)

        // Interface defaults as plain Java default methods, without the `DefaultImpls` shim that only code
        // compiled before Kotlin 2.2 needs. A new library has no such callers.
        jvmDefault.set(org.jetbrains.kotlin.gradle.dsl.JvmDefaultMode.NO_COMPATIBILITY)
    }
}

dependencies {
    // Only `@RequiresApi`, which is gone after compiling, so apps don't need to download it.
    compileOnly(libs.androidx.annotation)
    testImplementation(libs.junit)

    // The validator plugin adds these itself only for the modules it recognizes.
    "bcv-rt-jvm-cp"(libs.kotlin.metadata.jvm)
    "bcv-rt-jvm-cp"(libs.asm)
    "bcv-rt-jvm-cp"(libs.asm.tree)
}

// Public API tracking. `api/hapticengine.api` records the public API, and `check` fails if the API changes
// without that file being updated: after an intended change, run `./gradlew :hapticengine:apiDump` and
// commit the file. The validator plugin only sets itself up for the separate Kotlin Android plugin, and
// Kotlin's own `abiValidation` doesn't see classes from AGP 9's built-in Kotlin yet, so the tasks are wired
// to the release classes here.
val apiFile = layout.projectDirectory.file("api/hapticengine.api")

val apiBuild = tasks.register<KotlinApiBuildTask>("apiBuild") {
    inputClassesDirs.from(tasks.named("compileReleaseKotlin").map { it.outputs.files })
    outputApiFile.set(layout.buildDirectory.file("api/hapticengine.api"))
    runtimeClasspath.from(configurations.named("bcv-rt-jvm-cp-resolver"))
}

tasks.register<Copy>("apiDump") {
    description = "Records the current public API in api/hapticengine.api."
    from(apiBuild.flatMap { it.outputApiFile })
    into(apiFile.asFile.parentFile)
}

val apiCheck = tasks.register<KotlinApiCompareTask>("apiCheck") {
    description = "Fails if the public API differs from api/hapticengine.api."
    projectApiFile.set(apiFile)
    generatedApiFile.set(apiBuild.flatMap { it.outputApiFile })
}

tasks.named("check") { dependsOn(apiCheck) }
