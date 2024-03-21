import 'package:farmer_app/helpers/color_constants.dart';
import 'package:flutter/material.dart';

class HomeProductItemShimmer extends StatelessWidget {
  const HomeProductItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                "assets/images/banana.png",
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
                  width: 70,
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
                          'assets/images/vendor.png',
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
    );
  }
}
