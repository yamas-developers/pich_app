import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NearestStoreShimmer extends StatelessWidget {
  NearestStoreShimmer({Key? key,this.message = ''}) : super(key: key);
  String message = '';
  @override
  Widget build(BuildContext context) {
    return  Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
      child: Container( 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: Theme.of(context).primaryColor.withOpacity(.4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.red,
                child: Image.asset(
                  'assets/images/vendor.png',
                  height: 20,
                  width: 20,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: message.length >0?
                    Text(message,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),)
                    :Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 70,
                        height: 8.0,
                        color: kprimaryColor,
                      ),
                      SizedBox(height: 4,),
                      Container(
                        width: 150,
                        height: 8.0,
                        color: kprimaryColor,
                      ),
                    ],
                  ),
                ),
              Image.asset(
                'assets/icons/location_icon.png',
                width: 15,
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
