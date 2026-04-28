plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.new_verify_feild_worker"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

//    splits {
//        abi {
//            isEnable = true
//            reset()
//            include("arm64-v8a", "armeabi-v7a")
//            isUniversalApk = false
//        }
//    }

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
            isMinifyEnabled = true        // ✅ ON karo
            isShrinkResources = true      // ✅ ON karo
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug") // release key baad mein
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
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))
    implementation("com.google.mlkit:text-recognition:16.0.0")
    implementation("com.google.firebase:firebase-messaging")
}

apply(plugin = "com.google.gms.google-services")