import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../badge.dart';

class CompletedPaymentListShimmerItem extends StatelessWidget {
  const CompletedPaymentListShimmerItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child:

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Container(
            decoration: BoxDecoration(
                // border: Border.all(
                //   color: Colors.black12,
                // ),
                borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.5),
            ),
            padding: const EdgeInsets.all(10.0),
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
                  height: 3,
                ),
                Row(
                  children: [
                    Container(
                      width: 90,
                      height: 20,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    // Spacer(),
                    // Container(
                    //   width: 54,
                    //   height: 24,
                    //
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     color: Colors.white,
                    //   ),
                    // ),
                  ],
                ),
                ShimmerDivider(),
                Row(
                  children: [
                    Container(
                      width: 90,
                      height: 20,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 50,
                      height: 20,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ShimmerDivider(),
                Row(
                  children: [
                    Container(
                      width: 110,
                      height: 20,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 140,
                      height: 20,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ShimmerDivider(),
                Row(
                  children: [
                    Container(
                      width: 110,
                      height: 20,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 140,
                      height: 20,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ShimmerDivider(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
                  child: Row(
                    children: [
                      Container(
                        width: 140,
                        height: 28,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 24,
                        height: 24,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View All',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        baseColor: Colors.grey, highlightColor: Colors.white);
  }
}

class ShimmerDivider extends StatelessWidget {
  const ShimmerDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Divider(
        thickness: 1,
        height: 1,
        color: kdividershade.withOpacity(0.3),
        indent: 10,
        endIndent: 10,
      ),
    );
  }
}
class CompletedPaymentListShimmer extends StatelessWidget {
  const CompletedPaymentListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (i,context)=>CompletedPaymentListShimmerItem());
  }
}
