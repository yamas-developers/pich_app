import 'package:farmer_app/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeProduceBagItemShimmer extends StatelessWidget {
  const HomeProduceBagItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
        height: 91,
        decoration: BoxDecoration(
          color: itmGreyColor.withOpacity(.2),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  "assets/images/basket_4x.png",
                  width: 57,
                  height: 39,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 8.0,
                    color: kprimaryColor,
                  ),
                  Text(
                    '-- items',
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 11,
                          backgroundColor: Color.fromRGBO(249, 178, 51, 1),
                          child: Image.asset(
                            'assets/images/default_holder.png',
                            height: 11,
                            width: 11,
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 70,
                          height: 8.0,
                          color: kprimaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Text(
                '\$--',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}

class HomeProduceBagListShimmer extends StatelessWidget {
  const HomeProduceBagListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 4, itemBuilder: (i, context) => HomeProduceBagItemShimmer());
  }
}
