import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RecieItemShimmer extends StatelessWidget {
  const RecieItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        child:  Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 93,
            width: getWidth(context)-5,
            // width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .shadowColor
                  .withOpacity(.5),
              borderRadius: BorderRadius.circular(19),
              // color: kGreyColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 72,
                    height: 120,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                         color: kprimaryColor,
                         height: 15,
                         width: 100,
                       ),
                        SizedBox(height: 10,),
                        Container(
                          width:
                          MediaQuery.of(context).size.width * 0.6,
                          child:  Container(
                            height: 30,
                            width: 200,
                            color: kprimaryColor,
                          ),
                        ),
                      ],
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
class RecipeListSimmer extends StatelessWidget {
  const RecipeListSimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (i,context)=>RecieItemShimmer());
  }
}
