# Flutter Wrapper Keep Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# R8 Optimization Directives
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose

# Google Play Core & Play Store Deferred Components Rules for R8 Full Mode
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Firebase Messaging Keep Rules
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**

# Flutter Local Notifications & Activity Keep Rules
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class androidx.activity.** { *; }

# Android Desugaring Keep Rules
-keep class java.time.** { *; }
-dontwarn java.time.**