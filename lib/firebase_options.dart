// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCDBR2_Fmwm_EBDT9ENXYZdEBs9sy3T6RY',
    appId: '1:255319884654:web:46ee5f0801c9b8c6ef377f',
    messagingSenderId: '255319884654',
    projectId: 'fir-a1ab7',
    authDomain: 'fir-a1ab7.firebaseapp.com',
    storageBucket: 'fir-a1ab7.firebasestorage.app',
    measurementId: 'G-4HTYBX4J2Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrMxqJsotWqa_fD5JvGDNqnSeIIaVxDzc',
    appId: '1:255319884654:android:604aba64d7b9a59fef377f',
    messagingSenderId: '255319884654',
    projectId: 'fir-a1ab7',
    storageBucket: 'fir-a1ab7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCA7NUrErSHKRiPc0rdq9FsCxBrnlRce7s',
    appId: '1:255319884654:ios:66e9c56e20521180ef377f',
    messagingSenderId: '255319884654',
    projectId: 'fir-a1ab7',
    storageBucket: 'fir-a1ab7.firebasestorage.app',
    iosBundleId: 'com.example.amazon',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCA7NUrErSHKRiPc0rdq9FsCxBrnlRce7s',
    appId: '1:255319884654:ios:66e9c56e20521180ef377f',
    messagingSenderId: '255319884654',
    projectId: 'fir-a1ab7',
    storageBucket: 'fir-a1ab7.firebasestorage.app',
    iosBundleId: 'com.example.amazon',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCDBR2_Fmwm_EBDT9ENXYZdEBs9sy3T6RY',
    appId: '1:255319884654:web:ffacdbc85e685adaef377f',
    messagingSenderId: '255319884654',
    projectId: 'fir-a1ab7',
    authDomain: 'fir-a1ab7.firebaseapp.com',
    storageBucket: 'fir-a1ab7.firebasestorage.app',
    measurementId: 'G-4D783JM6TE',
  );
}
