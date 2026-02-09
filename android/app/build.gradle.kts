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
println(">>> App versionCode: ${flutter.versionCode}")
println(">>> App versionName: ${flutter.versionName}")

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
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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
    // On Android 12 and higher, the system ignores the old windowBackground settings
    // and instead uses the new mandatory launch screen. If not properly adapted,
    // it will display the system's default dark (or white) background.
    implementation("androidx.core:core-splashscreen:1.0.1")
}

flutter {
    source = "../.."
}
