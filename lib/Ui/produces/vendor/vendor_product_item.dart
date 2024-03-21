import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:flutter/material.dart';

class VendorProductItem extends StatelessWidget {
  const VendorProductItem(
      {Key? key,
      required this.storeProduct,
      required this.actionTitle,
      required this.actionCallback, this.onTap = null, this.id = ''})
      : super(key: key);

  final StoreProduct storeProduct;
  final String actionTitle;
  final String id;
  final actionCallback;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 7, 20, 7),
        height: 91,
        decoration: BoxDecoration(
          color: kGreyColor,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: Hero(
                  tag: id,
                  child: CacheImage(
                    url: "${MJ_Apis.APP_BASE_URL + storeProduct.products!.image!}",
                    width: 57,
                    height: 57,
                    fit: BoxFit.contain,
                  ),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${storeProduct.products!.productName}",
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    'Size ${storeProduct.size}',
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    // SizedBox(width: 5),
                    child: Text(
                      '\$${storeProduct.price}',
                      style: TextStyle(fontSize: 15, color: kprimaryColor),
                    ),
                  ),
                ],
              ),
            ),
            if (actionTitle != '')
              TouchableOpacity(
                onTap: actionCallback,
                child: Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Container(
                    height: 40,
                    width: 83,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: kYellowColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          actionTitle,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
