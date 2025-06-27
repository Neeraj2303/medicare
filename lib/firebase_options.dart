// File generated manually with Firebase options
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
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
    apiKey: 'AIzaSyBwFWsQ7M-zDINh4A4jOi6vmeVyAXRKzk8',
    appId: '1:694058093426:web:b9907208650c82bd65ebeb',
    messagingSenderId: '694058093426',
    projectId: 'medicine-dashboard-961f9',
    authDomain: 'medicine-dashboard-961f9.firebaseapp.com',
    storageBucket: 'medicine-dashboard-961f9.firebasestorage.app',
    measurementId: 'G-CHLF1SX5XB',
    databaseURL: 'https://medicine-dashboard-961f9-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwFWsQ7M-zDINh4A4jOi6vmeVyAXRKzk8',
    appId: '1:694058093426:web:b9907208650c82bd65ebeb',
    messagingSenderId: '694058093426',
    projectId: 'medicine-dashboard-961f9',
    storageBucket: 'medicine-dashboard-961f9.firebasestorage.app',
    databaseURL: 'https://medicine-dashboard-961f9-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwFWsQ7M-zDINh4A4jOi6vmeVyAXRKzk8',
    appId: '1:694058093426:web:b9907208650c82bd65ebeb',
    messagingSenderId: '694058093426',
    projectId: 'medicine-dashboard-961f9',
    storageBucket: 'medicine-dashboard-961f9.firebasestorage.app',
    iosBundleId: 'com.example.dashboard',
    databaseURL: 'https://medicine-dashboard-961f9-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwFWsQ7M-zDINh4A4jOi6vmeVyAXRKzk8',
    appId: '1:694058093426:web:b9907208650c82bd65ebeb',
    messagingSenderId: '694058093426',
    projectId: 'medicine-dashboard-961f9',
    storageBucket: 'medicine-dashboard-961f9.firebasestorage.app',
    iosBundleId: 'com.example.dashboard',
    databaseURL: 'https://medicine-dashboard-961f9-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBwFWsQ7M-zDINh4A4jOi6vmeVyAXRKzk8',
    appId: '1:694058093426:web:b9907208650c82bd65ebeb',
    messagingSenderId: '694058093426',
    projectId: 'medicine-dashboard-961f9',
    authDomain: 'medicine-dashboard-961f9.firebaseapp.com',
    storageBucket: 'medicine-dashboard-961f9.firebasestorage.app',
    measurementId: 'G-CHLF1SX5XB',
    databaseURL: 'https://medicine-dashboard-961f9-default-rtdb.firebaseio.com',
  );
}
