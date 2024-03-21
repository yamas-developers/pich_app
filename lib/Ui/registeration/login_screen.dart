// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:farmer_app/Ui/app_components/app_logo.dart';
import 'package:farmer_app/Ui/app_components/auth_screen_textfield.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_dashboard_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/Ui/home_produces/Home_Produces.dart';
import 'package:provider/src/provider.dart';

import '../home_screen.dart';
import 'otp_verification_screen.dart';
import 'signup-screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum radioChoices { vendor, customer }

TextEditingController emailCtrl = TextEditingController();
TextEditingController passwordCtrl = TextEditingController();
bool isLoading = false;
String emailErrorText = '';
String passwordErrorText = '';

radioChoices _radioGroup = radioChoices.vendor;
bool customerSelected = true;
bool shouldSubmit = true;

class _LoginScreenState extends State<LoginScreen> {
  submit() async {
    emailErrorText = '';
    passwordErrorText = '';
    shouldSubmit = true;

    if (emailCtrl.text.isEmpty || emailCtrl.text.trim() == '') {
      setState(() {
        emailErrorText = 'Please enter username / email';
      });
      shouldSubmit = false;
      // showToast("phone cannot be empty");
      // return;
    }
    if (passwordCtrl.text.isEmpty) {
      setState(() {
        passwordErrorText = 'Password can not be empty';
      });
      shouldSubmit = false;
    }

    if (passwordCtrl.text.isNotEmpty) {
      if (passwordCtrl.text.length < 8) {
        passwordErrorText = 'Your Password:';
        setState(() {
          passwordErrorText += '\n - Is not 8 characters long';
        });
        shouldSubmit = false;
      }
      // if (RegExp(r"[ ]+").hasMatch(passwordCtrl.text)) {
      //   passwordErrorText == '' ?  'Your Password:' : '';
      //   setState(() {
      //     passwordErrorText += '\n - Contains white spaces';
      //   });
      //   shouldSubmit = false;
      // }
      // if (!(RegExp(r"[[a-z]+[A-Z]+]|[[A-Z]+[a-z]+]").hasMatch(passwordCtrl.text))) {
      //   passwordErrorText == '' ?  'Your Password:' : '';
      //   setState(() {
      //     passwordErrorText += '\n - Does not contain upper and lower case characters';
      //   });
      //   shouldSubmit = false;
      // }
      // if (!(RegExp(r"[.!#$%&'*@+-/=?^_`{|}~]+").hasMatch(passwordCtrl.text))) {
      //   passwordErrorText == '' ?  'Your Password:' : '';
      //   print('in symbol if');
      //   setState(() {
      //     passwordErrorText += '\n - Does not contain at least one special symbol';
      //   });
      //   shouldSubmit = false;
      // }
    }

    if (shouldSubmit) {
      MjApiService apiService = MjApiService();
      dynamic payload = {
        "password": passwordCtrl.text,
        "email": emailCtrl.text,
      };
      print(payload);
      showProgressDialog(context, "Please wait", isDismissable: false);
      dynamic response =
          await apiService.simplePostRequest(MJ_Apis.login, payload);
      hideProgressDialog(context);
      if (response != null) {
        showToast(response['message']);
        if (response['status'] == 1) {
          User user = User.fromJson(response['response']["user"]);
          user.token = response['response']["token"];
          print('received userData: ${response['response']["user"]}');

          print(user.toJson());
          if (user.isPhoneVerified == 'Yes') {
            await setUser(user);
            await context.read<UserProvider>().setUser(user);
            if (await isLogin()) {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (context) => false);
            } else {
              showToast("You don't have access to this application");
            }
            //
            // if(user.rolesId == USER.toString()) {
            // }else if(user.rolesId == VENDOR.toString()){
            //   // Navigator.pushReplacementNamed(context, VendorDashboardScreen.routeName);
            // }else{
            //   showToast("You don't have access to this application");
            // }
          } else {
            Navigator.pushNamed(context, OtpVerificationScreen.routeName,
                arguments: {'user': user, 'returnToLogin': false});
          }

          // Navigator.of(context).pop();
          // Navigator.pushNamedAndRemoveUntil(context, MJRoutePaths.home, (route) => false);
          // Navigator.pushNamed(context, MJRoutePaths.otp,arguments: user);
        } else {
          // showToast("In")
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardAppeared = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    // Image.asset(
                    //   'assets/png/home_produces_tree.png',
                    //   height: 80,
                    //   width: 80,
                    // ),
                    SizedBox(
                      height: 44,
                    ),
                    Container(
                        width: getWidth(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Center(
                                child: AppLogo(
                              size: 30,
                            )),
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Login',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AuthScreenTextField(
                      errorText: emailErrorText,
                      controller: emailCtrl,
                      label: 'EMAIL or USERNAME',
                      icon: Icons.email,
                    ),
                    AuthScreenTextField(
                      errorText: passwordErrorText,
                      controller: passwordCtrl,
                      label: 'PASSWORD',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        submit();
                        // Navigator.pushNamed(context, HomeScreen.routeName);
                      },
                      child: SizedBox(
                        width: 260,
                        height: 35,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                // radius: 5,

                                stops: const [0.5, 0.99],
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Colors.lightGreen,
                                ],
                              )),
                          child: Center(
                            child: Text(
                              'Login',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, SignupScreen.routeName);
                          },
                          child: Text(
                            'Sign up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
          if (!isKeyboardAppeared)
            Positioned(
              right: -30,
              bottom: -105,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).accentColor,
              ),
            ),
          if (!isKeyboardAppeared)
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
