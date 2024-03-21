// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/chat/widgets/message_bubble.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/firebase/firebase_helper.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/conversation.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_profile.dart';
import 'package:farmer_app/providers/chat/conversation_provider.dart';
import 'package:farmer_app/providers/user/my_profile_provider.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class ChatDetail extends StatefulWidget {
  static const String routeName = "/chat_detail";

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  ScrollController listViewScrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  DatabaseReference chatRef = FirebaseDatabase.instance.ref().child('chats');
  User otherUserProfile = User();
  int? userId;
  String? otherUserId;
  bool isExist = false, init = false;
  bool isLoading = false;
  Conversation conversation = Conversation();
  bool initChat = false;

  // List<ChatMessage> messages = [];
  @override
  void initState() {
    // messages = [
    //   ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    //   ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    //   ChatMessage(messageContent: "Hey Kriss, I am doing fine dude. wbu?", messageType: "sender"),
    //   ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    //   ChatMessage(messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ];
    getPageData();
    // TODO: implement initState
    super.initState();

    checkChatData();
  }

  scrollToLast({fast = false}) async {
    try {
      bool _init = init;
      init = true;
      // await Future.delayed(Duration(milliseconds: 300));
      if (listViewScrollController.hasClients) {
        if (listViewScrollController.position == null) return;
        if (!_init) {
          await Future.delayed(Duration(milliseconds: 50));
          if (listViewScrollController.position != null)
            listViewScrollController
                .jumpTo(listViewScrollController.position.maxScrollExtent);
        }
        listViewScrollController.animateTo(
          listViewScrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: Duration(milliseconds: 500),
        );
        _init = true;
      } else {
        await Future.delayed(Duration(milliseconds: 100));
        if (!_init) scrollToLast();
      }
    } catch (e) {}
    listViewScrollController.addListener(() {
      // print("here");
    });
  }

  checkChatData() async {
    // print("checkChatData");
    await Future.delayed(Duration(milliseconds: 1));
    var data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      try {
        Map routeData = data as Map;
        // print("routeData: ${routeData}");
        // print("routeData: ${routeData}");
        if (routeData['type'] != null) {
          if (routeData['type'] == 'profile') {
            if (routeData['isExist']) {
              Conversation? conv = routeData['conversation'];
              if (conv != null) {
                chat_id = conv.id.toString();
                setState(() {
                  conversation = conv;
                  chat_id = chat_id;
                  isExist = true;
                });
              }
              User otherUser = routeData['user'];
              otherUserId = otherUser.id;
              return;
            } else {
              User otherUser = routeData['user'];
              if (otherUser != null) {
                otherUserId = otherUser.id;
                getChat();
              }
              isExist = false;
              return;
            }
          } else if (routeData['type'] == 'conversation') {
            Conversation? conv = routeData['conversation'];
            User user = (await getUser())!;
            if (conv != null) {
              chat_id = conv.id.toString();
              if (conv.getOtherUser(user.id) != null) {
                otherUserId = conv.getOtherUser(user.id)!.userId;
              }
              // chatRef = await chatRef.child(chat_id!).child('messages');
              setState(() {
                chat_id = chat_id;
                isExist = true;
                conversation = conv;
              });
            }
            // UserProfile otherUser = routeData['user'];
            // User user = (await getUser())!;
            otherUserId = conv!.getOtherUser(user.id)!.userId;
            updateChat("");
            return;
          }
        } else {}
        // getChat();
      } catch (e) {}
    }
  }

  Future getChat() async {
    print("getChat");
    try {
      User user = (await getUser())!;
      if (otherUserId == null) {
        if (conversation != null)
          otherUserId = conversation.getOtherUser(user.id)!.userId;
      }
      List list = [user.id, otherUserId];
      var payload = {"user_ids": jsonEncode(list)};
      var response = await MjApiService()
          .postRequest(MJ_Apis.get_chat + "/${user.id.toString()}", payload);
      if (response != null) {
        Conversation conversation = Conversation.fromJson(response);
        setState(() {
          isExist = true;
          chat_id = conversation.id.toString();
          this.conversation = conversation;
          otherUserId = conversation.getOtherUser(userId)!.userId;
        });
        // print("=======>${chat_id}");
      } else {
        showAlertDialog(
            context, "Cannot find", "Chat not found try again later",
            type: AlertType.WARNING,
            okButtonText: "Go Back",
            showCancelButton: false, onPress: () {
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      print(e);
      showAlertDialog(context, "Unfortunate error",
          "while creating chat an error encountered try again later",
          type: AlertType.WARNING,
          okButtonText: "Go Back",
          showCancelButton: false, onPress: () {
        Navigator.of(context).pop();
      });
      // return null;
    }
    return false;
  }

  User? currentUser = User();

  getPageData() async {
    context.read<UserProvider>().currentUser = (await getUser())!;
    currentUser = context.read<UserProvider>().currentUser;

    // scrollToLast();
  }

  updateChat(message, {type = 'simple'}) async {
    User user = (await getUser())!;
    List list = [user.id, otherUserId];
    // {"user_ids":"[2,11]","request_type":"simple","detail_user_id":11,"last_msg":"Hello World","unread_count":1,"my_user_id":"2","my_unread_count":0 }
    var payload;
    if (type == 'send')
      payload = {
        "user_ids": jsonEncode(list),
        "detail_user_id": otherUserId.toString(),
        "last_msg": message,
        "unread_count": "1",
        "my_user_id": user.id.toString(),
        "my_unread_count": "0",
        "last_msg_date":
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())
      };
    else
      payload = {
        "user_ids": jsonEncode(list),
        // "detail_user_id": otherUserId,
        // "last_msg": message,
        // "unread_count": 1,
        "my_user_id": user.id,
        "my_unread_count": "0",
      };
    print(payload);
    var response = await MjApiService().postRequest(
        MJ_Apis.update_chat + "/${user.id.toString()}/${chat_id.toString()}",
        payload);
    if (response != null) {
      Conversation conversation = Conversation.fromJson(response);
      context.read<ConversationProvider>().updateChat(conversation);
    }
  }

  @override
  void dispose() {
    listViewScrollController.dispose();
    super.dispose();
  }

  String? chat_id;
  String date = "";

  @override
  Widget build(BuildContext context) {
    // print("otherUserID: 1");
    print("otherUserID: ${otherUserProfile.id}");
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: Container(
            padding: EdgeInsets.all(10),
            child: AppBackButton(
              color: Colors.white,
              width: 20,
            )),
        title: (conversation.id == null && currentUser != null)
            ? Text(
                "Chat User",
                style: TextStyle(color: Colors.white),
              )
            : (conversation.getOtherUser(currentUser!.id) == null)
                ? SizedBox()
                : Column(
                    children: [
                      Text(
                        "${conversation.getOtherUser(currentUser!.id)!.user!.firstname}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "${conversation.getOtherUser(currentUser!.id)!.user!.email}",
                        style: TextStyle(
                            color: Colors.white.withOpacity(.8), fontSize: 12),
                      ),
                    ],
                  ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: kYellowColor,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                height: 35,
                width: _width,
                decoration: new BoxDecoration(
                    color: kYellowColor,
                    //new Color.fromRGBO(255, 0, 0, 0.0),
                    borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(40.0),
                        bottomRight: const Radius.circular(40.0))),
              ),
              conversation.id == null
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70.0,
                          height: 70.0,
                          transform: Matrix4.translationValues(0.0, 0, 0.0),
                          // padding: EdgeInsets.all(10),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(50.0)),
                            border: new Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: CacheImage(
                              url:
                                  '${MJ_Apis.APP_BASE_URL}${conversation.getOtherUser(currentUser!.id)!.user!.profileImage}',
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
          Expanded(
            child: chat_id != null && chat_id != ''
                ? FirebaseAnimatedList(
                    controller: listViewScrollController,
                    // reverse: true,
                    // sort: (a, b) {
                    //   final x = a.value as Map;
                    //   final y = b.value as Map;
                    //
                    //   final aTimestamp = x['timestamp'] as int;
                    //   final bTimestamp = y['timestamp'] as int;
                    //   log("${aTimestamp}, ${bTimestamp}");
                    //
                    //   return bTimestamp.compareTo(aTimestamp);
                    // },

                    physics: BouncingScrollPhysics(),
                    // shrinkWrap: false,

                    query: chatRef
                        .child(chat_id!)
                        .child('messages')
                        .orderByChild('timestamp'),

                    itemBuilder: (context, snapshot, animation, index) {
                      if(!init){
                        scrollToLast(fast: true);
                      }
                      log('MK: index of chat: ${index}');
                      Map snap = snapshot.value as Map;
                      var isOther =
                          snap['creater-id'] != currentUser!.id.toString();
                      return MessageBubble(
                          message: snap['message'] ?? '',
                          userName: !isOther
                              ? 'You'
                              : '${conversation.getOtherUser(currentUser!.id)!.user!.firstname}',
                          isOther: isOther,
                          key: ValueKey(snap['timestamp']),
                          url: snap['image'] ?? '',
                          type: snap['type'] ?? '',
                          timestamp: snap['timestamp']);

                      return SizeTransition(
                        sizeFactor: CurvedAnimation(
                            parent: animation, curve: Curves.easeOut),
                        child: MessageBubble(
                            message: snap['message'] ?? '',
                            userName: !isOther
                                ? 'You'
                                : '${conversation.getOtherUser(currentUser!.id)!.user!.firstname}',
                            isOther: isOther,
                            key: ValueKey(snap['timestamp']),
                            url: snap['image'] ?? '',
                            type: snap['type'] ?? '',
                            timestamp: snap['timestamp']),
                      );
                    },

                    defaultChild: Center(
                        child:
                            ColorCircularProgressIndicator(message: 'Loading')),
                  )
                : Center(
                    child: Text(
                      'Send a message to start a chat!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10, bottom: 20, top: 10, right: 7),
            height: 70,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                // Text("hello")
                /*  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  )
                   */

                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(fontWeight: FontWeight.w500),
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Type your message here...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                isLoading
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator())
                    : FloatingActionButton(
                        onPressed: () async {
                          if (messageController.text.isEmpty) {
                            return;
                          }
                          if ((conversation.id == null)) {
                            setState(() {
                              isLoading = true;
                            });
                            await getChat();
                            setState(() {
                              isLoading = false;
                            });
                          }
                          if (chat_id == null) {
                            showToast("cannot find chat");
                            return;
                          }
                          String key = await chatRef
                              .child(chat_id!)
                              .child('messages')
                              .push()
                              .key!;
                          DatabaseReference ref = await chatRef
                              .child(chat_id!)
                              .child('messages')
                              .child(key);
                          print('creater-id: ${currentUser!.id}');
                          var message = messageController.text;
                          ref.set({
                            "image": "url",
                            "message": messageController.text,
                            "message-id": 'message-id',
                            "creater-id": currentUser!.id.toString(),
                            "timestamp": DateTime.now().microsecondsSinceEpoch,
                            'type': 'text',
                            'from': 'app',
                          }).then((value) {
                            print('chat added');
                            context
                                .read<FirebaseHelper>()
                                .setMessageNotification(
                                    userId: conversation
                                        .getOtherUser(currentUser!.id)!
                                        .userId,
                                    count: 1,
                                    message: message);
                            updateChat(message, type: 'send');
                            scrollToLast();
                          });

                          messageController.text = '';
                        },
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        // child: Image.asset('assets/images/paper-plane.jpg'),
                        // Icon(Icons.pape,color: Colors.white,size: 18,),
                        backgroundColor: kYellowColor,
                        elevation: 0,
                      ),
              ],
            ),
          ),
          // ListView.builder(
          //   itemCount: 5,
          //   shrinkWrap: true,
          //   padding: EdgeInsets.only(top: 50, bottom: 10),
          //   physics: NeverScrollableScrollPhysics(),
          //   itemBuilder: (context, index) {
          //     return Container(
          //       padding:
          //           EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          //       child: Align(
          //         alignment: Alignment.topLeft,
          //         // alignment: (messages[index].messageType == "receiver"
          //         //   Alignment.topLeft
          //         // Alignment.topRight
          //         // ),
          //         child: Container(
          //           decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(20),
          //               // color: (messages[index].messageType  == "receiver"
          //               //      ?Colors.grey.shade200: darkTheme["primaryColor"]),
          //               color: kGrey),
          //           padding: EdgeInsets.all(16),
          //           child: Text(
          //             " Available",
          //             style: TextStyle(
          //                 fontSize: 15,
          //
          //                 // color: (messages[index].messageType  == "receiver"
          //                 //  ?Colors.black: darkTheme["primaryTextColor"]),
          //                 color: Colors.black),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
// int mySortComparison(Snapshot a, Snap b) {
//   final propertyA = a.time!;
//   final propertyB = b.time!;
//   if (propertyA < propertyB) {
//     return -1;
//   } else if (propertyA > propertyB) {
//     return 1;
//   } else {
//     return 0;
//   }
// }
