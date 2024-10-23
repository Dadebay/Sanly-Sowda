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
    apiKey: 'AIzaSyA42JgN0ln-trPNqafVY9emM9u4GsF2jPo',
    appId: '1:1077191499990:web:5b3ca39e99677dc95da977',
    messagingSenderId: '1077191499990',
    projectId: 'jummi-d106c',
    authDomain: 'jummi-d106c.firebaseapp.com',
    storageBucket: 'jummi-d106c.appspot.com',
    measurementId: 'G-1TYSP94X4Z',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCRrFgVzy2n5I6SbB9wffDuNuOe4Z1U30c',
    appId: '1:1077191499990:android:2da6f36a973a40d75da977',
    messagingSenderId: '1077191499990',
    projectId: 'jummi-d106c',
    storageBucket: 'jummi-d106c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2j-DcOl2KNDPMU117_FfmzpLwH1LXGaY',
    appId: '1:1077191499990:ios:2fc94e6b3777272a5da977',
    messagingSenderId: '1077191499990',
    projectId: 'jummi-d106c',
    storageBucket: 'jummi-d106c.appspot.com',
    iosBundleId: 'com.gurbanow.sanlysowda',
  );

}