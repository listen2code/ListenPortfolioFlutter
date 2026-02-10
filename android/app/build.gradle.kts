import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore/keystore.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Print Flutter properties for debugging
println(">>> Flutter compileSdkVersion: ${flutter.compileSdkVersion}")
println(">>> Flutter minSdkVersion: ${flutter.minSdkVersion}")
println(">>> Flutter targetSdkVersion: ${flutter.targetSdkVersion}")
println(">>> Flutter ndkVersion: ${flutter.ndkVersion}")
println(">>> Original App versionCode: ${flutter.versionCode}")
println(">>> Original App versionName: ${flutter.versionName}")

android {
    namespace = "com.listen.portfolio.listen_portfolio_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.listen.portfolio.listen_portfolio_flutter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        // Define which ABIs to include in the output (Exclude x86/x86_64)
        ndk {
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a"))
        }

        val vName = flutter.versionName ?: "1.0.0"
        versionName = vName

        // Auto-generate versionCode: 1.2.3 -> 10203
        versionCode = try {
            val parts = vName.split(".")
            val major = parts.getOrNull(0)?.toInt() ?: 0
            val minor = parts.getOrNull(1)?.toInt() ?: 0
            val patch = parts.getOrNull(2)?.filter { it.isDigit() }?.toInt() ?: 0
            major * 10000 + minor * 100 + patch
        } catch (e: Exception) {
            flutter.versionCode ?: 1
        }

        println(">>> Calculated Auto-Increment versionCode: $versionCode")
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?

            val storeFileName = keystoreProperties["storeFile"] as String?
            if (storeFileName != null) {
                storeFile = rootProject.file("keystore/$storeFileName")
            }

            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    // Because Android 12+ introduced a new Splash Screen API.
    implementation("androidx.core:core-splashscreen:1.0.1")
}

flutter {
    source = "../.."
}
