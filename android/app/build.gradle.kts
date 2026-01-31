plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

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

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
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
