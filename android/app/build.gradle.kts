plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Do NOT put `com.google.gms.google-services` here in plugins block
}

android {
    namespace = "com.example.new_verify_feild_worker"
    compileSdk = 36
    ndkVersion = "27.0.12077973"


    defaultConfig {
        applicationId = "com.example.new_verify_feild_worker"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"

    }


    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
    }


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.annotation:annotation:1.9.1")
    testImplementation("junit:junit:4.13.2")

    // Required for Java 8 language features (used by flutter_local_notifications, etc.)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Firebase BOM for unified SDK versions
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // Firebase Messaging SDK
    implementation("com.google.firebase:firebase-messaging")
}

// Apply the Google services plugin the legacy way here:
apply(plugin = "com.google.gms.google-services")
