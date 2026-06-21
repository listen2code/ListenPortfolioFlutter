// File: lib/firebase_options.dart
// Dummy configuration to allow compilation and boot-up of Firebase services.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDm5BgpmtV8o0y0yJnm18sJIy040p3Y7vo',
    appId: '1:766904702962:web:0298fe535747578073bd6b',
    messagingSenderId: '766904702962',
    projectId: 'lportofolioflutter',
    authDomain: 'lportofolioflutter.firebaseapp.com',
    storageBucket: 'lportofolioflutter.firebasestorage.app',
    measurementId: 'G-Y67T0J3X9L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCV2VLzfHjj5-DiZmJM0DDae-28zQpETVo',
    appId: '1:766904702962:android:0f289ddf906e98f473bd6b',
    messagingSenderId: '766904702962',
    projectId: 'lportofolioflutter',
    storageBucket: 'lportofolioflutter.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUe1YdWkuR4xjCAVMq-nA6BbJ9SM7onFw',
    appId: '1:766904702962:ios:e3ced0b6eb5720c873bd6b',
    messagingSenderId: '766904702962',
    projectId: 'lportofolioflutter',
    storageBucket: 'lportofolioflutter.firebasestorage.app',
    iosBundleId: 'com.listen.portfolio.listenPortfolioFlutter',
  );
}
