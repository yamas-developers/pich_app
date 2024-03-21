import 'dart:io';
import 'dart:math';

import 'package:farmer_app/Ui/chat/ConversationList.dart';
import 'package:farmer_app/Ui/custom_components/custom_bottom_nav_bar.dart';
import 'package:farmer_app/Ui/home_produces/Home_Produces.dart';
import 'package:farmer_app/Ui/posts/post_list.dart';
import 'package:farmer_app/Ui/user_profile/ProfileScreen.dart';
import 'package:farmer_app/Ui/user_profile/user_dynamic_forms.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_dashboard_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/dynamic_form.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/notification/notificationservice.dart';
import 'package:farmer_app/providers/user/user_dynamic_form_provider.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/Ui/search/search_screen_sheet.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/src/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/screen_home";

  HomeScreen({Key? key}) : super(key: key);

  // final String userType;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  NotificationService notificationService = NotificationService();

  int currentIndex = 0;
  User? user;
  getFormData() async {
    User _user = (await getUser())!;
    context.read<UserDynamicFormProvider>().isLoading = true;
    var response =
    await MjApiService().getRequest(MJ_Apis.get_forms + "/${_user.id}");
    context.read<UserDynamicFormProvider>().isLoading = false;
    if (response != null) {
      List<DynamicForm> list = [];
      print(response);
      for (int i = 0; i < response.length; i++) {
        if (response[i]['field'] == null) {
          continue;
        }
        if (response[i]['field'].length < 1) {
          continue;
        }
        if (DynamicForm.fromJson(response[i]).userForm == null) {
          list.add(DynamicForm.fromJson(response[i]));
        }
      }
      if(list.length > 0){
        Navigator.pushReplacementNamed(
            context, UserDynamicForms.routeName,arguments: {"from":"home"});
        return false;
      }
      context.read<UserDynamicFormProvider>().set(list);
    }
    return true;
  }
  Future<void> getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    await context.read<UserProvider>().setUser(user!);
    if(user!.rolesId.toString() != VENDOR) {
      await getFormData();
    }
    print("================>GETING TOKEN<=====================");

    _firebaseMessaging.getToken().then((String? token) async {
      assert(token != null);
      setState(() {
        //_homeScreenText = "Push Messaging token: $token";
      });
      print("================>TOKEN<=====================");
      print(token);
      print("================>TOKEN<=====================");

      _firebaseMessaging.subscribeToTopic("all");
      Function fun = (tkn) async {
        var request = {
          "fcm_token": tkn,
        };
        var res = await MjApiService()
            .simplePostRequest(MJ_Apis.update_user + '/${user!.id}', request);

        print('payload: ${request}');
        print('res: ${res}');
      };
      if (await isLogin()) {
        fun(token);
      }
      print(token);
      // print(_homeScreenText);
    });
  }

  convertMessage(RemoteMessage message) {
    // message["data"] = message;
    try {
      var notification = {
        "title": message.data['aps']['title'],
        "body": message.data['aps']['body'],
        "data": message.data,
      };

      return notification;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showFlutterNotification(RemoteMessage fcmMessage) {
    debugPrint("show flutter notification");
    try {
      Map msg = fcmMessage.data;
      debugPrint("======+>Before Converted message");
      debugPrint(msg.toString());
      if (Platform.isIOS) {
        msg = convertMessage(fcmMessage);
      } else {
        msg = {
          "title": msg['notification']['title'],
          "body": msg['notification']['body'],
          "data": msg,
        };
      }
      debugPrint("======+>Converted message");
      debugPrint(msg.toString());
      NotificationService().showFloatingNotification(
          Random().nextInt(10000), msg['title'], msg['body'], 01);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    getPageData().then((value) {
      setState(() {});
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        FirebaseMessaging.onMessage.listen(showFlutterNotification);
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint('A new onMessageOpenedApp event was published!');
          // Navigator.pushNamed(
          //   context,
          //   '/message',
          //   arguments: MessageArguments(message, true),
          // );
        });
      });
    });
    notificationService.isAndroidPermissionGranted();
    notificationService.requestPermissions();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardAppeared = MediaQuery.of(context).viewInsets.bottom != 0;
    print('keyboard appeared in homescreen: ${isKeyboardAppeared}');
    if (user != null) {
      print('userID: ${user!.rolesId}');
    }
    return Scaffold(
      body: user == null
          ? CircularProgressIndicator()
          : CustomBottomNavBar(
              isKeyboardAppeared: isKeyboardAppeared,
              currentIndex: currentIndex,
              items: <Widget>[
                user!.rolesId != VENDOR
                    ? ShowCaseWidget(builder: Builder(builder: (context) {
                        return HomeProduces(
                          key: widget.key,
                        );
                      }))
                    : ShowCaseWidget(
                        builder: Builder(builder: (context) {
                          return VendorDashboardScreen(key: widget.key);
                        }),
                      ),
                //Home
                ShowCaseWidget(
                  builder: Builder(builder: (context) {
                    return PostScreen(key: widget.key);
                  }),
                ),
                //File
                ShowCaseWidget(
                  builder: Builder(builder: (context) {
                    return ConversationList(key: widget.key);
                  }),
                ),
                //Chat
                SearchScreenSheet(key: widget.key),
                //Search
                // user!.rolesId == VENDOR ? VendorProfile() :
                Profile(key: widget.key),
                //Profile
                // Container(),
                // Container(),
              ],
              onChange: (index) {
                // if (index == 3) {
                //   bottomModalSearch(context);
                // } else {
                setState(() {
                  currentIndex = index;
                });
                // }
              },
            ),
    );
  }

// Future bottomModalSearch(BuildContext context) {
//   return showModalBottomSheet(
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
//       context: context,
//       builder: (context) {
//         return SearchScreenSheet();
//       });
// }
}
