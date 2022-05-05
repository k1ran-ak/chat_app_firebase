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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDWCZKUPkSerjg7YvnpcUBd4Weps_uQ5-w',
    appId: '1:188222682231:web:312ab749ec6dc3f6ac8272',
    messagingSenderId: '188222682231',
    projectId: 'chatapp-63f7b',
    authDomain: 'chatapp-63f7b.firebaseapp.com',
    databaseURL: 'https://chatapp-63f7b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'chatapp-63f7b.appspot.com',
    measurementId: 'G-ZETS987NMX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVOC2QfRVeN8dE-2ryJaYA3mJWzaX4GzI',
    appId: '1:188222682231:android:84e57c145fac5524ac8272',
    messagingSenderId: '188222682231',
    projectId: 'chatapp-63f7b',
    databaseURL: 'https://chatapp-63f7b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'chatapp-63f7b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3vmwiOo8YVrpKjZ5eJ7pVk4g0SYxCI4o',
    appId: '1:188222682231:ios:8a97c61addbfc835ac8272',
    messagingSenderId: '188222682231',
    projectId: 'chatapp-63f7b',
    databaseURL: 'https://chatapp-63f7b-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'chatapp-63f7b.appspot.com',
    iosClientId: '188222682231-o4nrk8pf2te7mv5islf3obc2n1ds43vi.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApp',
  );
}