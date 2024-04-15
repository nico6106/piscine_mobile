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
    apiKey: 'AIzaSyBkpo55VDB78zZwHxU0DupJf6NU-TQkHYA',
    appId: '1:94041003599:web:975baa900b2112cd687c3a',
    messagingSenderId: '94041003599',
    projectId: 'diaryapp-d7200',
    authDomain: 'diaryapp-d7200.firebaseapp.com',
    storageBucket: 'diaryapp-d7200.appspot.com',
    measurementId: 'G-G4MXJHDVTP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyOo1g3FtsYIioHKe12OLQUMMBExurvyw',
    appId: '1:94041003599:android:d2b4cbe1404a562f687c3a',
    messagingSenderId: '94041003599',
    projectId: 'diaryapp-d7200',
    storageBucket: 'diaryapp-d7200.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBkpo55VDB78zZwHxU0DupJf6NU-TQkHYA',
    appId: '1:94041003599:web:93d7b5c7a01245e2687c3a',
    messagingSenderId: '94041003599',
    projectId: 'diaryapp-d7200',
    authDomain: 'diaryapp-d7200.firebaseapp.com',
    storageBucket: 'diaryapp-d7200.appspot.com',
    measurementId: 'G-TRYLL2GCNB',
  );

}