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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvLOTM7Sac4d6NNXOwm2jpLHVnPYZjBq4',
    appId: '1:1027857206923:android:1a9dcc5c17a8aa3a8c4e8e',
    messagingSenderId: '1027857206923',
    projectId: 'chat-8208c',
    storageBucket: 'chat-8208c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAqoXFGirXsFohVyqxza-Qfmr45efZii5M',
    appId: '1:1027857206923:ios:cf1c0f81c64757158c4e8e',
    messagingSenderId: '1027857206923',
    projectId: 'chat-8208c',
    storageBucket: 'chat-8208c.appspot.com',
    androidClientId: '1027857206923-cdfgrg0fjj302q2bnm80ievafvfma7n8.apps.googleusercontent.com',
    iosClientId: '1027857206923-0js24asc9e54o9l2iccrmogpoj3tpbnl.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatKoro',
  );
}