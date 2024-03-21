import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../badge.dart';

class PendingRequestItemShimmer extends StatelessWidget {
  const PendingRequestItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: (true) ? Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 15),
          child: Container(
            height: 210,
            // width: getWidth(context),
            padding: const EdgeInsets.symmetric(
                vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 110,
                      height: 24,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 90,
                      height: 24,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 54,
                      height: 24,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: 90,
                      height: 24,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 94,
                      height: 24,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Container(
                      width: 110,
                      height: 24,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 140,
                      height: 24,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: getWidth(context) * .70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          SizedBox(width: 40,),
                          Container(
                            width: 10,
                            height: 10,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5,),
                          // Spacer(),
                          Container(
                            width: 10,
                            height: 10,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: kprimaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 10,),
                  ],
                ),
              ],
            ),
          ),
        ) : Column(
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
