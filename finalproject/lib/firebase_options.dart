// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD1y7--qilzDleuG_SIPjU80Q8k3x3Wvcc',
    appId: '1:1010909698567:web:8f8fb685884d23838be8a2',
    messagingSenderId: '1010909698567',
    projectId: 'final-25e79',
    authDomain: 'final-25e79.firebaseapp.com',
    storageBucket: 'final-25e79.appspot.com',
    measurementId: 'G-7L2ZDKFVWS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYKaGATCObZ2LnfKgTkSns-cg2R2JYV-s',
    appId: '1:1010909698567:android:bfbffbafc06525268be8a2',
    messagingSenderId: '1010909698567',
    projectId: 'final-25e79',
    storageBucket: 'final-25e79.appspot.com',
  );
}
