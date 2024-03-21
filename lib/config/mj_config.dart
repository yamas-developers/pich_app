

import 'package:firebase_core/firebase_core.dart';

class MJConfig{

  static const String mj_session_user = "user";
  static const String please_wait = "Please Wait.";

  static FirebaseOptions firebaseIOSOptions =  FirebaseOptions(
    databaseURL: 'https://pichfarmerapp-default-rtdb.firebaseio.com/',
    apiKey: 'AIzaSyBXt6TXDDEjvCg-o2J7-AF9i8WDghth-T4',
    appId: '1:477538002455:ios:bd6dbd3d9f0000bb4ade52',
    messagingSenderId: '477538002455',
    projectId: 'pichfarmerapp',
    storageBucket: 'pichfarmerapp.appspot.com',
  );
  static FirebaseOptions firebaseAndroidOptions =  FirebaseOptions(
    databaseURL: 'https://pichfarmerapp-default-rtdb.firebaseio.com/',
    apiKey: 'AIzaSyBXt6TXDDEjvCg-o2J7-AF9i8WDghth-T4',
    appId: '1:477538002455:android:bd6dbd3d9f0000bb4ade52',
    messagingSenderId: '477538002455',
    projectId: 'pichfarmerapp',
    storageBucket: 'pichfarmerapp.appspot.com',
  );
}