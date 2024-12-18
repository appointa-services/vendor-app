// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

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
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTxcJDd6OHZjkDzzAoNnL1zmOCP7aZ-y4',
    appId: '1:212237749630:android:c27f51a24829c15d52f72f',
    messagingSenderId: '212237749630',
    projectId: 'saloon-ae3be',
    storageBucket: 'saloon-ae3be.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBBICZYa-hqM6qRzH5F5LM0sNfpfCTpQTI',
    appId: '1:212237749630:ios:45db7cebd0d6d98852f72f',
    messagingSenderId: '212237749630',
    projectId: 'saloon-ae3be',
    storageBucket: 'saloon-ae3be.appspot.com',
    iosBundleId: 'com.salonuserapp.mobile',
  );
}
