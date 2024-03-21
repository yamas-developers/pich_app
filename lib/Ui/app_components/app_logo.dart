import 'package:farmer_app/helpers/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  double size = 18;
  AppLogo({this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/home_produces_tree.png",
          width: size,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "PICH",
          style: TextStyle(
              fontSize: size , color: logoTitleClr, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 4,
        ),
        Container(
          height: size,
          width: 2,
          color: logoRed,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          "Partnership to Improve \nCommunity Health",
          style: TextStyle(fontSize: size/2.5, color: kYellowColor),
          textAlign: TextAlign.start,
        )
      ],
    );
  }
}
