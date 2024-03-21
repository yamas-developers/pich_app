import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../badge.dart';

class PostCommentShimmerItem extends StatelessWidget {
  const PostCommentShimmerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child:

        Column(
          children: [
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                           ),
                        borderRadius: BorderRadius.circular(40)),
                    // radius: 25,
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Container(height: 40, width: 40,color: kprimaryColor,)),
                    )),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: kprimaryColor,
                      height: 16,
                      width: 110,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: kprimaryColor,
                      height: 14,
                      width: 60,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Badge(
                      value: 'Role',
                    )
                  ],
                ),
              ],
            ),
            Divider(color: kprimaryColor,),
          ],
        ),
        baseColor: Colors.grey, highlightColor: Colors.white);
  }
}
class PostCommentListShimmer extends StatelessWidget {
  const PostCommentListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 7,
        itemBuilder: (i,context)=>PostCommentShimmerItem());
  }
}
