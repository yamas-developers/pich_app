import 'package:farmer_app/Ui/app_components/app_logo.dart';
import 'package:farmer_app/Ui/app_components/auth_screen_textfield.dart';
import 'package:farmer_app/Ui/home_screen.dart';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:provider/provider.dart';
import '../../helpers/color_constants.dart';
import '../../models/user.dart';
import 'package:pinput/pinput.dart';
import 'package:farmer_app/helpers/session_helper.dart';

class OtpVerificationScreen extends StatefulWidget {
  static const String routeName = "/otp_screen";

  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _pinPutController = TextEditingController();
  User? user;

  int enteredPin = 0;
  String? _verId;
  int? _resendToken;
  bool initialized = false;
  bool? returnToLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var userData = ModalRoute.of(context)!.settings.arguments as Map;
    if (userData != null) {
      user = userData['user'] as User;
      returnToLogin = userData['returnToLogin'];
      print('userData: ${user!.toJson()}');
      if (!initialized) {
        sendOtp();
        initialized = true;
      }
    }
    super.didChangeDependencies();
  }

  _verificationCompleted(auth.PhoneAuthCredential credential) {
    print('authCredentials in Verification Completed: $credential');
  }

  _verificationFailed(auth.FirebaseAuthException e) {
    print('exception: $e');
  }

  _codeSent(String verificationId, int? resendToken) {
    _verId = verificationId;
    _resendToken = resendToken;

    print('verID: $verificationId');
    print('resendToken: $resendToken');

    // String smsCode = '123456';

    // Create a PhoneAuthCredential with the code
    // auth.PhoneAuthCredential credential = auth.PhoneAuthProvider.credential(
    //     verificationId: verificationId, smsCode: smsCode);
    // print('credentials in codeSent: $credential');

    // Sign the user in (or link) with the credential
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    print('verificationId in timeout: $verificationId');
  }

  sendOtp() async {
    await auth.FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${user!.phoneNumber}',
      // user!.phoneNumber!,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verificationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
      forceResendingToken: _resendToken,
      timeout: Duration(seconds: 60),
    );
  }

  verifyOtp() async {
    print('myTag in verifyOtp');
    final auth.PhoneAuthCredential credential =
        auth.PhoneAuthProvider.credential(
            verificationId: _verId ?? '', smsCode: _pinPutController.text);

    try {
      showProgressDialog(context, "Verifying One Time Passscode",
          isDismissable: false);
      //show progress dialogue
      await auth.FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((auth.UserCredential verifiedUser) async {
        print('myTag in signinwithcredentials');

        if (verifiedUser != null) {
          MjApiService apiService = MjApiService();

          dynamic paylaod = {
            "username": user!.username,
            "email": user!.email,
            "is_phone_verified": "Yes",
          };
          print('myTag in before calling api, payload: $paylaod');

          dynamic response = await apiService.simplePostRequest(
              MJ_Apis.update_user + "/${user!.id}", paylaod);
          print('response in OTP screen: ${response}');
          print(response['username'].toString());

          hideProgressDialog(context);

          if (response != null) {
            print('response status: ' + response['status'].toString());
            showToast(response['message']);
            // print('status: ${response['status']}');
            if (response['status'] == 1) {
              User user = User.fromJson(response['response']['user']);
              user.token = response['response']['token'];

              await setUser(user);
              await context.read<UserProvider>().setUser(user);
              if (await isLogin()) {
                if (returnToLogin ?? true)
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.routeName, (context) => false);
                else
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeScreen.routeName, (context) => false);
              } else {
                showToast("You don't have access to this application");
              }
            }
          }
          //go to login screen
        }
        //dismiss dialogu
      });
    } on Exception {
      //handle exception
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
          Column(
            // mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            'Verify One Time Passcode',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 1, 12, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Sent to ${user?.phoneNumber}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    buildPinPut(
                        // controller: _pinPutController,
                        // label: 'ENTER OTP',
                        // icon: Icons.verified_outlined,
                        ),
                    SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await verifyOtp();

                        /////
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
                              'Verify',
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
                          'Didn\'t get OTP?',
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
                          onPressed: () async {
                            await sendOtp();
                          },
                          child: Text(
                            'Resend',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Or',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        if (await logout()) {
                          context.read<CartHelper>().clearCart();
                          clearVendorData(context);
                          showToast("You are now logged out");
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        } else {
                          showToast("Cannot logout right now");
                        }
                      },
                      child: Text(
                        'Logout Now',
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
              )
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

  Widget buildPinPut() {
    final defaultPinTheme = PinTheme(
      // margin: EdgeInsets.all(5),
      width: 40,
      height: 43,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(200, 200, 200, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      controller: _pinPutController,
      keyboardType:
          TextInputType.numberWithOptions(signed: false, decimal: false),
      length: 6,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      showCursor: true,
      onCompleted: (pin) {
        print(pin);
      },
    );
  }
}
