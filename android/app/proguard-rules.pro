# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# MLKit
-keep class com.google.mlkit.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Your app models (API response classes)
-keep class com.example.new_verify_feild_worker.** { *; }
# Play Core (Flutter deferred components)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }