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
        return ios;
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
    apiKey: 'AIzaSyBgkQcB0mqCBqpth2CbVdPwwfny61nHvXM',
    appId: '1:121811408038:web:cdb0cc51b62c169df55067',
    messagingSenderId: '121811408038',
    projectId: 'workspace-32636',
    authDomain: 'workspace-32636.firebaseapp.com',
    storageBucket: 'workspace-32636.appspot.com',
    measurementId: 'G-TXBL22H0G2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2xNz2aHKJWocZsqI1iuazwSe4vqEh2UQ',
    appId: '1:121811408038:android:c00c27596c8891d5f55067',
    messagingSenderId: '121811408038',
    projectId: 'workspace-32636',
    storageBucket: 'workspace-32636.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBplVhc0ppODhmWYGORjBGkg0fplc9Vjxc',
    appId: '1:121811408038:ios:2a1c389badac24c0f55067',
    messagingSenderId: '121811408038',
    projectId: 'workspace-32636',
    storageBucket: 'workspace-32636.appspot.com',
    iosClientId: '121811408038-cq90s3pfg0obt0ci431qvkcu4mn5t2qt.apps.googleusercontent.com',
    iosBundleId: 'com.example.workSpace',
  );
}
