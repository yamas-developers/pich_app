import 'dart:ui';

import 'package:farmer_app/Ui/app_components/app_logo.dart';
import 'package:farmer_app/Ui/app_components/auth_screen_textfield.dart';
import 'package:farmer_app/Ui/home_produces/Home_Produces.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_dashboard_screen.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/mj_api_service.dart';
import '../../api/mj_apis.dart';
import '../../helpers/color_constants.dart';
import '../../helpers/constraints.dart';
import '../../models/user.dart';
import '../home_screen.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

enum radioChoices { vendor, customer }

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController userNameCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  // TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isLoading = false;

  radioChoices _radioGroup = radioChoices.vendor;
  bool customerSelected = true;
  String firstNameErrorText = '';
  String lastNameErrorText = '';
  String emailErrorText = '';
  String userNameErrorText = '';
  String phoneErrorText = '';
  String passwordErrorText = '';
  bool shouldSubmit = true;
  String phonePrefixText = "+1";
  String completePhoneNumber = "";

  submit() async {

    // if (firstNameCtrl.text == '') {
    //   User user = User();
    //   Navigator.pushNamed(context, OtpVerificationScreen.routeName,
    //       arguments: user);
    //   // return;
    // }
    completePhoneNumber = phonePrefixText + phoneCtrl.text;
    firstNameErrorText = '';
    lastNameErrorText = '';
    emailErrorText = '';
    userNameErrorText = '';
    phoneErrorText = '';
    passwordErrorText = '';
    shouldSubmit = true;

    print('phoneNumber: ${completePhoneNumber}');
    // return;

    if (!RegExp(r"^[A-Za-z' ]{3,}$").hasMatch(firstNameCtrl.text)) {
      if (firstNameCtrl.text.isEmpty) {
        firstNameErrorText = 'Please enter first name';
      } else {
        setState(() {
          firstNameErrorText = 'First name is not valid';
        });
        // return;
      }
      shouldSubmit = false;
    }
    if (!RegExp(r"^[A-Za-z' ]{3,}$").hasMatch(lastNameCtrl.text)) {
      if (lastNameCtrl.text.isEmpty) {
        setState(() {
          lastNameErrorText = 'Please enter last name';
        });
      } else {
        setState(() {
          lastNameErrorText = 'Last name is not valid';
        });
      }
      // return;
      shouldSubmit = false;
    }
    if (userNameCtrl.text.isEmpty || userNameCtrl.text.trim() == '') {
      setState(() {
        userNameErrorText = 'Please enter username';
      });
      shouldSubmit = false;
      // showToast("phone cannot be empty");
      // return;
    }
    // if (!RegExp(r'((\+[0-9]{1,3}))[ -]?3([0-9]{2})[ -]?[0-9]{4}[ -]?[0-9]{3}$')
    if (!RegExp(r'^[0-9]{10}$')
        .hasMatch(phoneCtrl.text)) {
      if (phoneCtrl.text.isEmpty) {
        setState(() {
          phoneErrorText = 'Please enter phone';
        });
      } else {
        setState(() {
          phoneErrorText = 'Please enter valid phone e.g ${phonePrefixText}1234567890';
        });
      }
      shouldSubmit = false;
      // return;
    }

    if (!(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailCtrl.text))) {
      if (emailCtrl.text.isEmpty) {
        emailErrorText = 'Please enter email';
      } else {
        setState(() {
          emailErrorText = 'Email is not valid';
        });}

        shouldSubmit = false;
        // return;
      }

      if (passwordCtrl.text.isEmpty) {
        setState(() {
          passwordErrorText = 'Password can not be empty';
        });
      shouldSubmit = false;
      }

    if (passwordCtrl.text.isNotEmpty) {

      if (passwordCtrl.text.length<8) {
        passwordErrorText = 'Password:';
        setState(() {
          passwordErrorText += '\n - Must be at least 8 characters long';
        });
        shouldSubmit = false;
      }
      if (RegExp(r"[ ]+").hasMatch(passwordCtrl.text)) {
        passwordErrorText == '' ?  'Password:' : '';
        setState(() {
          passwordErrorText += '\n - Must not contain white spaces';
        });
        shouldSubmit = false;
      }
      if (!(RegExp(r"[a-zA-Z]+[A-Za-z]+").hasMatch(passwordCtrl.text))) {
        passwordErrorText == '' ?  'Password:' : '';
        setState(() {
          passwordErrorText += '\n - Must contain upper and lower case characters';
        });
        shouldSubmit = false;
      }
      if (!(RegExp(r"[.!#$%&'*@+-/=?^_`{|}~]+").hasMatch(passwordCtrl.text))) {
        passwordErrorText == '' ?  'Password:' : '';
        print('in symbol if');
        setState(() {
          passwordErrorText += '\n - Must contain at least one special symbol';
        });
        shouldSubmit = false;
      }
    }

    if (shouldSubmit) {
      MjApiService apiService = MjApiService();
      dynamic paylaod = {
        "firstname": firstNameCtrl.text.trim(),
        "lastname": lastNameCtrl.text.trim(),
        "username": userNameCtrl.text.trim(),
        "phone_number": completePhoneNumber,
        "password": passwordCtrl.text,
        "email": emailCtrl.text,
        "roles_id": customerSelected ? USER : VENDOR,
      };

      showProgressDialog(context, MJConfig.please_wait);
      print('payload: $paylaod');
      dynamic response =
          await apiService.simplePostRequest(MJ_Apis.signup, paylaod);
      hideProgressDialog(context);
      print('responseImp: ${response}');
      // print(response['user_name'].toString());
      if (response != null) {
        print('response status: ' + response['status'].toString());
        showToast(response['message']);
        // print('status: ${response['status']}');
        if (response['status'] == 1) {
          User user = User.fromJson(response['response']['user']);
          user.token = response['response']['token'];
          Navigator.pushNamed(context, OtpVerificationScreen.routeName,
              arguments: {'user': user});
        } else {}
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
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 60,
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
                        children: [
                          Text(
                            'Registration',
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
                      errorText: firstNameErrorText,
                      controller: firstNameCtrl,
                      label: 'FIRST NAME',
                      icon: Icons.person,
                    ),
                    AuthScreenTextField(
                      errorText: lastNameErrorText,
                      controller: lastNameCtrl,
                      label: 'LAST NAME',
                      icon: Icons.person_outline,
                    ),
                    AuthScreenTextField(
                      errorText: userNameErrorText,
                      controller: userNameCtrl,
                      label: 'USER NAME',
                      icon: Icons.account_circle,
                    ),
                    AuthScreenTextField(
                      hintText: ' 1234567890',
                      showNonNumericDigits: false,
                      prefixText: phonePrefixText,
                      inputType: TextInputType.number,
                      errorText: phoneErrorText,
                      controller: phoneCtrl,
                      label: 'PHONE',
                      icon: Icons.phone_android_rounded,
                    ),
                    AuthScreenTextField(
                      errorText: emailErrorText,
                      controller: emailCtrl,
                      label: 'EMAIL',
                      icon: Icons.email,
                    ),
                    AuthScreenTextField(
                      errorText: passwordErrorText,
                      controller: passwordCtrl,
                      label: 'PASSWORD',
                      obscureText: true,
                      icon: Icons.lock,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Create Account As '),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: containerGreyShade,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      customerSelected = false;
                                    });
                                  },
                                  child: Container(
                                    height: 34,
                                    decoration: BoxDecoration(
                                        color: customerSelected
                                            ? null
                                            : Theme.of(context).accentColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      'Vendor',
                                      style: TextStyle(
                                          color: customerSelected
                                              ? Theme.of(context).primaryColor
                                              : Colors.white),
                                    )),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      customerSelected = true;
                                    });
                                  },
                                  child: Container(
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: customerSelected
                                          ? Theme.of(context).accentColor
                                          : null,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                        child: Text(
                                      'Customer',
                                      style: TextStyle(
                                          color: customerSelected
                                              ? Colors.white
                                              : Theme.of(context).primaryColor),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        submit();
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

                                stops: [0.5, 0.99],
                                colors: [
                                  Theme.of(context).primaryColor,
                                  Colors.lightGreen,
                                ],
                              )),
                          child: Center(
                            child: Text(
                              'Sign up',
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
                          'Have account?',
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
                                context, LoginScreen.routeName);
                          },
                          child: Text(
                            'Sign in',
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
                    )
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
