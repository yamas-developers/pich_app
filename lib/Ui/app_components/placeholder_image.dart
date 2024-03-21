import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';

class PlaceHolderImage extends StatelessWidget {
  double? height;
  double? width;
  String? url = '';
  BoxFit? fit = BoxFit.contain;

  PlaceHolderImage({Key? key, this.height, this.width, this.url = '',this.fit = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: AssetImage('assets/images/loading-image.gif'),
      image: NetworkImage(url!),
      imageErrorBuilder: (a, b, c) =>
          Image.asset("assets/images/default_holder.png", width: width ,
            height: height ,  fit: fit,),
      width: width ,
      height: height ,
      fit: fit,
    );
  }
}
