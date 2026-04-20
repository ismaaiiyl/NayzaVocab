## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

## Google Play Core (Fix for R8 missing classes)
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

## Hive
-keep class com.mongodb.** { *; }
-dontwarn com.mongodb.**

## Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

## General
-dontwarn android.window.OnBackInvokedCallback
-dontwarn androidx.window.extensions.layout.WindowLayoutComponent
-dontwarn androidx.window.sidecar.SidecarInterface
