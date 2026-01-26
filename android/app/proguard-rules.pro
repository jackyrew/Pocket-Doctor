# Keep generic signatures (VERY IMPORTANT)
-keepattributes Signature

# Keep flutter_local_notifications internals
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Gson / TypeToken (used internally)
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class com.google.gson.** { *; }
