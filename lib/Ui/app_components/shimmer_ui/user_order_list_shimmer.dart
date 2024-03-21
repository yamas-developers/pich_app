import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../badge.dart';

class UserOrderShimmerItem extends StatelessWidget {
  const UserOrderShimmerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child:

        Container(
          height: 135,
          margin: EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(19)),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              color: Colors.white,
                              height: 18,
                              width: 80,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/bag.png",
                              height: 21,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Container(color: kprimaryColor,height: 18,width: 80,),
                          ],
                        ),

                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Vouchers Total:",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight:
                                  FontWeight.w500),
                            ),
                          ],
                        ),
                        Container(color: kprimaryColor,height: 18,width: 50,)
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
                child: Divider(
                  thickness: 2,
                  height: 2,
                  color: kdividershade,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 13,
                              backgroundColor:
                              kYellowColor,
                              child: Image.asset(
                                  "assets/icons/vendor.png",
                                  height: 13),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Container(color: Colors.white,height: 20,width: 80,),
                            SizedBox(
                              width: 4,
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.only(
                                  top: 3.0),
                              child: Image.asset(
                                "assets/icons/angular.png",
                                height: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12.0),
                    child: Column(
                      children: [
                        Container(color: kprimaryColor,height: 18,width: 70,)
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        baseColor: Colors.grey, highlightColor: Colors.white);
  }
}
class UserOrderListShimmer extends StatelessWidget {
  const UserOrderListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (i,context)=>UserOrderShimmerItem());
  }
}
