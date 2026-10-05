# WorkManager (pulled in by Google Mobile Ads) builds its database through Room
# reflectively at app startup. Without these keep rules R8 strips
# androidx.room.Room in release builds and the app crashes on launch with
# "Failed to create an instance of androidx.work.impl.WorkDatabase".
-keep class androidx.room.** { *; }
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
