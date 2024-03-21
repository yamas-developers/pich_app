import 'package:farmer_app/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfileHeaderShimmer extends StatelessWidget {
  const ProfileHeaderShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Column(
          children: [
            Center(
              child: Container(
               width: 200,
                height: 10,
                color: kprimaryColor,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/location_icon.png",
                  height: 12,
                ),
                SizedBox(
                  width: 4,
                ),
                Container(
                  width: 100,
                  height: 8.0,
                  color: kprimaryColor,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .shadowColor
                        .withOpacity(.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withOpacity(.4))),
                child: Flex(
                  direction: Axis.horizontal,
                  // mainAxisAlignment:
                  //     MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(children: [
                        Text(
                          "Followers",
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8,),
                        Container(
                          width: 50,
                          height: 10,
                          color: kprimaryColor,
                        ),
                      ]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(children: [
                        Text(
                          "Following",
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8,),
                        Container(
                          width: 50,
                          height: 10,
                          color: kprimaryColor,
                        ),
                      ]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(children: [
                        Text(
                          "Posts",
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8,),
                        Container(
                          width: 50,
                          height: 10,
                          color: kprimaryColor,
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ), baseColor: Colors.grey, highlightColor: Colors.white);
  }
}
class ProfileImageSimmer extends StatelessWidget {
  const ProfileImageSimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey, highlightColor: Colors.white,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 50,
        child: Image.asset("assets/images/Ellipse.png"),
      ),
    );
  }
}
