import 'dart:io';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/providers/mj_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'helpers/router_helper.dart' as router;
import 'notification/notificationservice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();

  Future<FirebaseApp> firebaseApp = Firebase.initializeApp(
    // name: "PICH",
    options: Platform.isIOS
        ? MJConfig.firebaseIOSOptions
        : MJConfig.firebaseAndroidOptions,
  );
  // await Firebase.initializeApp().then((value) {
  runApp(MyApp());
  // });
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...providers,
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Farmer App',
        theme: ThemeData(
          accentColor: kYellowColor,
          primaryColor: kprimaryColor,
          fontFamily: "Montserrat",
          textTheme: TextTheme(
              bodyText2: TextStyle(
            fontWeight: FontWeight.w500,
          )),
          primarySwatch: Colors.green,
          // backgroundColor: backgroundGreyShade,
        ),
        // home: LoginScreen(),
        initialRoute: '/',
        // routes: routes,
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}
