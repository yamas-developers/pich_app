import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../badge.dart';

class OtherVendorStoreShimmerItem extends StatelessWidget {
  const OtherVendorStoreShimmerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child:

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              color: Colors.white10,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red,
                      child: Container(
                        width: 20,
                        height: 20,
                      )
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: kprimaryColor,
                          height: 16,
                          width: 110,
                        ),
                        SizedBox(height: 5,),
                        Container(
                          color: kprimaryColor,
                          height: 25,
                          width: 150,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    padding: EdgeInsets.fromLTRB(8,6,8,6),
                    decoration: BoxDecoration(
                      color: kprimaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    ),
                ],
              ),
            ),
          ),
        ),
        baseColor: Colors.grey, highlightColor: Colors.white);
  }
}
class OtherVendorStoreListShimmer extends StatelessWidget {
  const OtherVendorStoreListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (i,context)=>OtherVendorStoreShimmerItem());
  }
}
