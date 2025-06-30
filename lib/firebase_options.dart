import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyC_aakpsCW0KTnsNM41Qoo1Cf3-og3lKZQ',
      appId: '1:579836751307:android:805f16d0573ede1f7b1a4e',
      messagingSenderId: '579836751307',
      projectId: 'palp-deployment-practice',
      storageBucket: 'palp-deployment-practice.firebasestorage.app',
    );
  }
}

// class DefaultFirebaseOptions {
//   static FirebaseOptions get currentPlatform {
//     return const FirebaseOptions(
//       apiKey: 'AIzaSyA8aSXgLkH_PVoF0-lzrzzxDlA8BIVlIuM', 
//       appId: '1:607824099473:android:40115bf7db3b57daea6730', 
//       messagingSenderId: '607824099473', 
//       projectId: 'palpnote', 
//       storageBucket: 'palpnote.firebasestorage.app', 
//     );
//   }
// }