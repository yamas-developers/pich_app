import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VoucherItemShimmer extends StatelessWidget {
  const VoucherItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Shimmer.fromColors(
        child: Container(
          height: 100,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/icons/background.png",
                ),
                fit: BoxFit.fill),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(isPortrait ? 60 : 120, 15, 0, 10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Expiry",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 50,
                          color: kprimaryColor,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: isPortrait ? 30.0 : 50),
                child: Container(
                  height: 20,
                  width: 50,
                  color: kprimaryColor,
                ),
              ),
            ],
          ),
        ),
        baseColor: Colors.grey,
        highlightColor: Colors.white);
  }
}

class VoucherListShimmer extends StatelessWidget {
  const VoucherListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 4, itemBuilder: (i, context) => VoucherItemShimmer());
  }
}
