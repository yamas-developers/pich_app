import 'package:farmer_app/Ui/home_screen.dart';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/material.dart';

import '../intro_screen.dart';
import 'app_components/app_logo.dart';
import 'app_components/intro_slider.dart';
import 'registeration/otp_verification_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getPageData() async {
    User user = (await getUser())!;

    await Future.delayed(Duration(milliseconds: 1000));
    if (await isLogin()) {
      if (user.isPhoneVerified != 'Yes') {
        Navigator.pushNamedAndRemoveUntil(
            context, OtpVerificationScreen.routeName, (context) => false,
            arguments: {'user': user});
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (context) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, IntroScreen.routeName, (context) => false);
    }
  }

  @override
  void initState() {
    getPageData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: getHeight(context) * .10,
              ),
              Image.asset(
                "assets/images/logo.gif",
                height: 80,
              ),
              SizedBox(
                height: getHeight(context) * .20,
              ),
              Container(
                  width: getWidth(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: AppLogo(
                        size: 30,
                      )),
                    ],
                  )),
            ],
          ),
          Positioned(
            left: -35,
            top: -85,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).accentColor,
            ),
          ),
          Positioned(
            left: -95,
            top: -30,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          Positioned(
            right: -30,
            bottom: -105,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).accentColor,
            ),
          ),
          Positioned(
            right: -95,
            bottom: -65,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
