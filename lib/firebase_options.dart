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
        return macos;
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
    apiKey: 'AIzaSyBkOK7PChIoRuvVa2yur161A1P-gM0ahLs',
    appId: '1:805152365554:web:ecefb2e114da04417f296b',
    messagingSenderId: '805152365554',
    projectId: 'doctors-02',
    authDomain: 'doctors-02.firebaseapp.com',
    databaseURL: 'https://doctors-02-default-rtdb.firebaseio.com',
    storageBucket: 'doctors-02.appspot.com',
    measurementId: 'G-44FKDC6GHM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwccd4snUkiwdrnxEz0mrt1pSroBboxkQ',
    appId: '1:805152365554:android:bd43d28c7cb70a7b7f296b',
    messagingSenderId: '805152365554',
    projectId: 'doctors-02',
    databaseURL: 'https://doctors-02-default-rtdb.firebaseio.com',
    storageBucket: 'doctors-02.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBtdVwDT1WlfoVTX0AZajIu2qUGknuXzWw',
    appId: '1:805152365554:ios:c1e5770070d84e4a7f296b',
    messagingSenderId: '805152365554',
    projectId: 'doctors-02',
    databaseURL: 'https://doctors-02-default-rtdb.firebaseio.com',
    storageBucket: 'doctors-02.appspot.com',
    iosBundleId: 'com.example.docotors02',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBtdVwDT1WlfoVTX0AZajIu2qUGknuXzWw',
    appId: '1:805152365554:ios:a0f5a710c2d9b21b7f296b',
    messagingSenderId: '805152365554',
    projectId: 'doctors-02',
    databaseURL: 'https://doctors-02-default-rtdb.firebaseio.com',
    storageBucket: 'doctors-02.appspot.com',
    iosBundleId: 'com.example.docotors02.RunnerTests',
  );
}
