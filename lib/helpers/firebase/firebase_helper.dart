import 'dart:async';

import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class FirebaseHelper extends ChangeNotifier {
  // static String users = "/admin";
  int localNotifications = 0;
  int chatMessageNotifications = 0;
  bool initChatNotification = false;
  StreamSubscription<DatabaseEvent>? chatMessagesRef = null;
  final database = FirebaseDatabase.instance;

  initLocalNotifications() async {
    User user = (await getUser())!;
    database
        .ref("users/${user.id}/user_notification")
        .onValue
        .listen((event) {
          if(event.snapshot.value != null) {
            localNotifications = (event.snapshot.value as Map)['count'] ?? 0;
            notifyListeners();
            debugPrint(event.snapshot.value.toString());
          }
    }, onError: (error) {});
  }
  initChatMessagesNotifications() async {
    User user = (await getUser())!;
    if(chatMessagesRef != null){
      chatMessagesRef!.cancel();
    }
    chatMessagesRef = database
        .ref("users/${user.id}/chat_notifications")
        .onValue
        .listen((event) {
      if(event.snapshot.value != null) {
        chatMessageNotifications = (event.snapshot.value as Map)['count'];
        if(chatMessageNotifications > 0 && initChatNotification){
          showSnakBar(title: "New Message", message: "You have received new message");
        }
        initChatNotification = true;;
        notifyListeners();
        debugPrint(event.snapshot.value.toString());
      }
    }, onError: (error) {});
  }

  setLocalNotification(count) async {
    User user = (await getUser())!;
    database.ref('users/${user.id}/user_notification').set({"count": 0});
  }
  setMessageNotification({required userId, required count, required message}){
    print('users/${userId}/chat_notifications');
    database.ref('users/${userId}/chat_notifications').set({"count": count,"message":"${message}"});
  }

}
