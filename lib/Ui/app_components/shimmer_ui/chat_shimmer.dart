import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ConversationShimmer extends StatelessWidget {
  const ConversationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context,index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              margin: EdgeInsets.only(top: 10),
              color: kprimaryColor.withOpacity(.5),
              padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/loading-image.gif',
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 8.0,
                                  color: kprimaryColor,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Container(
                                  width: getWidth(context) / 2,
                                  height: 8.0,
                                  color: kprimaryColor,
                                ),
                                SizedBox(height: 3,),
                                Container(
                                  width: getWidth(context) / 3,
                                  height: 8.0,
                                  color: kprimaryColor,
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 8.0,
                    color: kprimaryColor,
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
