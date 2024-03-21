import 'package:flutter/material.dart';

import '../../helpers/color_constants.dart';

class BuildPost extends StatefulWidget {
  const BuildPost({Key? key}) : super(key: key);

  @override
  _BuildPostState createState() => _BuildPostState();
}

class _BuildPostState extends State<BuildPost> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Image.asset(
                    "assets/images/Ellipse.png"),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Jessica Melinda",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "12 Jan 2022",
                          style:
                          TextStyle(color: kGreyColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Image.asset("assets/icons/about.png")
            ],
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Container(
          height: 260,
          width: width,
          child: Image.asset(
            "assets/images/post.png",
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Row(
            children: [
              Image.asset("assets/icons/Heart.png"),
              SizedBox(
                width: 4,
              ),
              Text(
                "143k",
                style: TextStyle(
                    fontSize: 10, color: kGreyColor),
              ),
              SizedBox(
                width: 40,
              ),
              Image.asset("assets/icons/message.png"),
              SizedBox(
                width: 4,
              ),
              Text(
                "143k",
                style: TextStyle(
                    fontSize: 10, color: kGreyColor),
              ),
              SizedBox(
                width: 40,
              ),
              Image.asset("assets/icons/share.png")
            ],
          ),
        ),
      ],
    );
  }
}
