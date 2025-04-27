# Amazon Clone

A Flutter app that mimics Amazon's look and functionality. Uses Firebase for authentication and data storage.

## Features

- User authentication (login/registration)
- Product listing and search
- Product detail view
- Shopping cart
- Ratings and reviews
- Promotions page
- User profile management

## Setup

### 1. Flutter Setup

Make sure you have Flutter installed on your machine. If not, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).

```bash
# Check Flutter installation
flutter doctor
```

### 2. Firebase Setup

This app uses Firebase for authentication and cloud storage. You need to set up a Firebase project:

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project
2. Set up Authentication with Email/Password sign-in enabled
3. Create a Firestore database with the following collections:
   - `products`: For storing product information
   - `carts`: For storing user cart information
   - `feedbacks`: For storing product reviews
   - `promotions`: For storing promotional offers

### 3. Connect Firebase to Your App

#### Android Setup:
1. Add your Android app to Firebase project and download `google-services.json`
2. Place the file in `android/app/` directory
3. Ensure your `android/build.gradle` has the Google services plugin:
   ```groovy
   buildscript {
       dependencies {
           classpath 'com.google.gms:google-services:4.3.15'
       }
   }
   ```
4. Also ensure your `android/app/build.gradle` has:
   ```groovy
   apply plugin: 'com.google.gms.google-services'
   ```

#### iOS Setup:
1. Add your iOS app to Firebase project and download `GoogleService-Info.plist`
2. Place the file in `ios/Runner/` directory using Xcode
3. Open `ios/Runner.xcworkspace` with Xcode, right-click on Runner directory > Add files to "Runner"
4. Select the downloaded `GoogleService-Info.plist` file

### 4. Install Dependencies

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
  ├── models/        # Data models
  ├── providers/     # State management
  ├── screens/       # App screens
  ├── services/      # Firebase services
  ├── widgets/       # Reusable widgets
  ├── main.dart      # App entry point
  └── firebase_options.dart # Firebase config
```

## Sample Data

Use the following structure to add sample data to your Firestore collections:

### Products
```json
{
  "name": "Product Name",
  "price": 99.99,
  "description": "Detailed product description...",
  "imageUrls": [
    "https://example.com/image1.jpg",
    "https://example.com/image2.jpg"
  ],
  "rating": 4.5,
  "reviewCount": 120
}
```

### Promotions
```json
{
  "title": "Special Offer",
  "description": "Get 20% off on all electronics",
  "imageUrl": "https://example.com/promo-banner.jpg",
  "expiryDate": "Timestamp (date)"
}
```
