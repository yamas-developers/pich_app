import 'package:farmer_app/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeStoreItemShimmer extends StatelessWidget {
  const HomeStoreItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
          child: Container(
            // width: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                color: containerGreyShade.withOpacity(.2)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    maxRadius: 13,
                    backgroundColor: Colors.red,
                    child: Image.asset(
                      'assets/images/vendor.png',
                      width: 14,
                      height: 14,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 70,
                    height: 8.0,
                    color: kprimaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        baseColor: Colors.grey,
        highlightColor: Colors.white);
  }
}

class HomeStoreListShimmer extends StatelessWidget {
  const HomeStoreListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        itemBuilder: (i,context)=>HomeStoreItemShimmer());
  }
}
