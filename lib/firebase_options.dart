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
    apiKey: 'AIzaSyDiJunJGsmJrtS3pVhnbJz5Oqoc-qKN1RM',
    appId: '1:202213371458:web:9424ecab18daf8d32647db',
    messagingSenderId: '202213371458',
    projectId: 'moneywave-884c2',
    authDomain: 'moneywave-884c2.firebaseapp.com',
    storageBucket: 'moneywave-884c2.appspot.com',
    measurementId: 'G-PD8WCS20YE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQihL_GwDPoyznO2KF3HDRy91YriHaN4g',
    appId: '1:202213371458:android:ddef5a1a34a4626f2647db',
    messagingSenderId: '202213371458',
    projectId: 'moneywave-884c2',
    storageBucket: 'moneywave-884c2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDN3pZr_8kB39Ev6DGZmbDnvNwmzDCZanw',
    appId: '1:202213371458:ios:029ee04ed9482e8b2647db',
    messagingSenderId: '202213371458',
    projectId: 'moneywave-884c2',
    storageBucket: 'moneywave-884c2.appspot.com',
    androidClientId: '202213371458-htvlejjn8dqbiqtd0l4uinndu04lgl4m.apps.googleusercontent.com',
    iosClientId: '202213371458-d5p9fktqiejin02mgrj5uil0v8pmu3ou.apps.googleusercontent.com',
    iosBundleId: 'com.example.mwave',
  );

}