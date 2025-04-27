# iOS Firebase Setup Guide

This guide will help you set up Firebase in your iOS application.

## 1. Add Firebase to your iOS app

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Click on the iOS icon (&#x2795; Add app) to add a new iOS app
4. Register your app:
   - **iOS bundle ID**: `com.example.amazon` (or your bundle ID)
   - **App nickname**: Amazon Clone (optional)
   - **App Store ID**: Leave empty (unless you already have one)
5. Click **Register app**
6. Download the `GoogleService-Info.plist` file

## 2. Add `GoogleService-Info.plist` to your project

1. Open your Flutter project's iOS folder in Xcode:
   ```bash
   cd ios
   open Runner.xcworkspace
   ```

2. Right-click on the Runner directory in the Xcode Project Navigator
3. Select "Add Files to 'Runner'"
4. Select the downloaded `GoogleService-Info.plist` file
5. Make sure "Copy items if needed" is checked
6. Click "Add"
7. Ensure the file appears in your Runner directory

## 3. Update Podfile

Open `ios/Podfile` and ensure it has the following:

```ruby
platform :ios, '12.0'  # Set this to at least 12.0

# ...

target 'Runner' do
  use_frameworks!
  use_modular_headers!
  
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  # Add Firebase pods if needed
  # pod 'Firebase/Core'
  # pod 'Firebase/Auth'
  # pod 'Firebase/Firestore'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    # This ensures compatibility with iOS versions
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

## 4. Initialize Firebase in your app

This is already taken care of in the Flutter code with:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## 5. Install dependencies

Run:

```bash
cd ios
pod install
cd ..
```

## 6. Update iOS Info.plist (if needed)

Depending on Firebase features you use, you might need to add entries to `ios/Runner/Info.plist`. For example, if using Firebase Cloud Messaging:

```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<string>NO</string>
```

## 7. Run your app

Now you can run your app with Firebase integration:

```bash
flutter run
```

## Troubleshooting

### 1. CocoaPods issues

If you encounter CocoaPods issues, try:

```bash
cd ios
pod repo update
pod install --repo-update
```

### 2. Minimum iOS version

Ensure your app's minimum iOS version is compatible with the Firebase SDK (iOS 12.0 or higher recommended).

### 3. Firebase SDK issues

If you encounter issues with specific Firebase features, check the [Firebase documentation](https://firebase.google.com/docs/ios/setup) for the most up-to-date setup instructions.

### 4. Build errors

If you encounter build errors, make sure your Xcode is up to date and check that the Firebase SDK is compatible with your iOS version. 