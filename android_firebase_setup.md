# Android Firebase Setup Guide

This guide will help you set up Firebase in your Android application.

## 1. Add Firebase to your Android app

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Click on the Android icon (&#x2795; Add app) to add a new Android app
4. Register your app:
   - **Android package name**: `com.example.amazon` (or your package name)
   - **App nickname**: Amazon Clone (optional)
   - **Debug signing certificate SHA-1**: Add this if you plan to use Google Sign-In
5. Click **Register app**
6. Download the `google-services.json` file

## 2. Add `google-services.json` to your project

1. Move the downloaded `google-services.json` file into your project's `android/app/` directory

## 3. Configure Gradle files

### In `android/build.gradle`:

```groovy
buildscript {
    ext.kotlin_version = '1.7.10'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // Add the Google services Gradle plugin
        classpath 'com.google.gms:google-services:4.3.15'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

### In `android/app/build.gradle`:

Add the following line at the end of the file, after `apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"`:

```groovy
apply plugin: 'com.google.gms.google-services'
```

And make sure you have the Firebase dependencies:

```groovy
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation platform('com.google.firebase:firebase-bom:32.3.1')
    implementation 'com.google.firebase:firebase-analytics'
}
```

## 4. Update Android configuration (if needed)

### minSdkVersion

In `android/app/build.gradle`, ensure your `minSdkVersion` is at least 19:

```groovy
defaultConfig {
    applicationId "com.example.amazon"
    minSdkVersion 19   // Set this to at least 19
    targetSdkVersion flutter.targetSdkVersion
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
    multiDexEnabled true
}
```

### Add multidex support (if minSdkVersion < 21)

If your `minSdkVersion` is less than 21, add the following to your dependencies:

```groovy
dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation 'androidx.multidex:multidex:2.0.1'
    // ... other dependencies
}
```

And update your Android application class in `android/app/src/main/java/com/example/amazon/MainActivity.java`:

```java
import io.flutter.embedding.android.FlutterActivity;
import androidx.multidex.MultiDex;
import android.content.Context;

public class MainActivity extends FlutterActivity {
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
```

## 5. Run your app

Now you can run your app with Firebase integration:

```bash
flutter run
```

If you encounter any issues, check the Firebase documentation or run `flutter doctor` to ensure your Flutter setup is working correctly. 