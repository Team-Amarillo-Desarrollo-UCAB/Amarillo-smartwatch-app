# Mantén las clases de WearOS necesarias
-keep class com.google.android.wearable.compat.** { *; }
-dontwarn com.google.android.wearable.compat.**

# Mantén las clases del plugin Flutter Wear
-keep class com.mjohnsullivan.flutterwear.wear.** { *; }
-dontwarn com.mjohnsullivan.flutterwear.wear.**
