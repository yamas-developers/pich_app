import 'package:farmer_app/Ui/home_screen.dart';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/material.dart';

import 'Ui/app_components/intro_slider.dart';
import 'Ui/registeration/signup-screen.dart';
import 'Ui/app_components/app_logo.dart';

class IntroScreen extends StatefulWidget {
  static const String routeName = '/intro_screen';

  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  getPageData() async {
    // User user = (await getUser())!;
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
          Container(
            height: getHeight(context),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: getHeight(context) * .03,
                  ),
                  // Image.asset(
                  //   "assets/images/home_produces_tree.png",
                  //   height: 40,
                  // ),
                  SizedBox(
                    height: 20,
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
                  SizedBox(
                    height: 30,
                  ),
                  IntroScreenSlider(),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pushReplacementNamed(context, LoginScreen.routeName);


                    },
                    child: SizedBox(
                      width: 260,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              // radius: 5,

                              stops: const [0.5, 0.99],
                              colors: [
                                kYellowColor,
                                Colors.orange,
                              ],
                            )),
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context,
                              SignupScreen.routeName
                          );
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
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     SizedBox(height: getHeight(context)*.30,),
          //     Image.asset(
          //       "assets/images/home_produces_tree.png",
          //       height: 60,
          //     ),
          //     SizedBox(height: 20,),
          //     Container(
          //
          //         width: getWidth(context),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Center(
          //                 child: AppLogo(
          //                   size: 30,
          //                 )),
          //           ],
          //         )),
          //
          //   ],
          // ),
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

class IntroScreenSlider extends StatefulWidget {
  const IntroScreenSlider({Key? key}) : super(key: key);

  @override
  State<IntroScreenSlider> createState() => _IntroScreenSliderState();
}

class _IntroScreenSliderState extends State<IntroScreenSlider> {

  @override
  void initState() {
    super.initState();
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.arrow_forward,
      color:kprimaryColor,
      size: 20,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
        Icons.done,
        color: kprimaryColor
    );
  }

  Widget renderPrevBtn() {
    return Icon(
      Icons.arrow_back,
      color: kprimaryColor,
      size: 20,
    );
  }


  void onDonePress() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: IntroSlider(
        // slides: slides,
        onDonePress: this.onDonePress,
        renderPrevBtn: this.renderPrevBtn(),

        // Next button
        renderNextBtn: this.renderNextBtn(),

        // Done button
        renderDoneBtn: this.renderDoneBtn(),

        // Dot indicator
        colorDot: kprimaryColor,
        showSkipBtn: false,
        sizeDot: 10,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,

        // Tabs
        listCustomTabs: [
          IntroSliderItem(
              title: 'Welcome!',
              subTitle: "Slide to learn more",
              description:
              "Place where you can access fresh fruits so easily, efficiently and effectively"),
          IntroSliderItem(
              title: 'Stay Healthy!',
              subTitle: "Slide to learn more",
              showImage: true,
              imagePath: "assets/images/basket_4x.png",
              description:
              "Fresh fruits help you to stay as healthy and active as possible"),
          IntroSliderItem(
              title: 'What do we do?',
              subTitle: "Get Started",
              showImage: true,
              imagePath: "assets/icons/home_produces_tree.png",
              description:
              "PICH is an initiative to enable you to access the healthiest diet possible and available nearby"),
        ],
        backgroundColorAllSlides: Colors.transparent,
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }
}

class IntroSliderItem extends StatelessWidget {
  IntroSliderItem({
    Key? key,
    required this.title,
    required this.description,
    required this.subTitle,
    this.showImage = true,
    this.imagePath = '',
  }) : super(key: key);

  final String title;
  final String description;
  final String subTitle;
  String imagePath;
  bool showImage;

  TextStyle _style = TextStyle(color: kprimaryColor, fontSize: 24);
  TextStyle _style2 = TextStyle(color: kYellowColor, fontSize: 18);
  TextStyle _style3 = TextStyle(color: kGreyText, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            // color: Colors.grey,
            height: 35,
            child: Center(
              child: Text(
                title,
                style: _style,
              ),
            ),
          ),
          SizedBox(
              height: 160,
              width: 300,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if(showImage && imagePath != '')Image.asset(
                      "${imagePath}",
                      height: 70,
                    ),
                    if(showImage && imagePath != '')SizedBox(height: 20,),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: _style2,
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 30,
          ),
          // Spacer(),
          SizedBox(
            height: 100,
            child: Text(
              subTitle,
              style: _style3,
            ),
          ),
        ],
      ),
    );
  }
}
