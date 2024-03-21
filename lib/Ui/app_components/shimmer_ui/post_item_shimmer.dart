import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostItemShimmer extends StatelessWidget {
  const PostItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child:  Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: [
                  ClipRRect(
                    // backgroundColor: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      "assets/images/default_holder.png",
                      width: 50,height: 50,),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 100,
                              height: 8.0,
                              color: kprimaryColor,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 120,
                              height: 8.0,
                              color: kprimaryColor,
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
            // if(widget.postData!.description != null)
              Container(
                padding: EdgeInsets.only(left: 10),
                width: getWidth(context),
                child: Container(
                  width: getWidth(context),
                  height: 8.0,
                  color: kprimaryColor,
                ),
              ),
            SizedBox(
              height: 6,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 260,
                width: getWidth(context),
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Row(
                children: [
                  Image.asset("assets/icons/Heart.png",height: 22,
                    color: Colors.grey[600],
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 30,
                    height: 8.0,
                    color: kprimaryColor,
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Image.asset("assets/icons/message.png",height: 22,),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                    width: 30,
                    height: 8.0,
                    color: kprimaryColor,
                  ),
                  // SizedBox(
                  //   width: 40,
                  // ),
                  // Image.asset("assets/icons/share.png")
                ],
              ),
            ),
          ],
        ), baseColor: Colors.grey, highlightColor: Colors.white);
  }
}
class PostListSimmer extends StatelessWidget {
  const PostListSimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (i,context)=>PostItemShimmer());
  }
}
