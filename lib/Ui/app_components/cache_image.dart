import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CacheImage extends StatelessWidget {
  double? height;
  double? width;
  String? url = '';
  BoxFit? fit = BoxFit.contain;

  CacheImage(
      {Key? key,
      this.height,
      this.width,
      this.url = '',
      this.fit = BoxFit.contain})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, s) => Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: Image.asset(
            'assets/images/loading-image.gif',
            width: width,
            fit: BoxFit.cover,
            height: height),
      ),
      imageUrl: url!,
      errorWidget: (a, b, c) => Image.asset(
        "assets/images/default_holder.png",
        width: width,
        height: height,
        fit: fit,
      ),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
