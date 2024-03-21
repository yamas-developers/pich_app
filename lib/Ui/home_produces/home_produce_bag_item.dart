import 'package:date_format/date_format.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/home_produces/basket_cart.dart';
import 'package:farmer_app/Ui/home_produces/single_item_cart.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:flutter/material.dart';

import '../../helpers/color_constants.dart';

class HomeProductBagItem extends StatefulWidget {
  int? id;
  StoreProduceBag? storeProduceBag;

  HomeProductBagItem({@required this.id, @required this.storeProduceBag});

  @override
  State<HomeProductBagItem> createState() => _HomeProductBagItemState();
}

class _HomeProductBagItemState extends State<HomeProductBagItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, _, __) => BasketCartActivity(
                id: "produce_bag_${widget.id!}",
                bag: widget.storeProduceBag!,
              )),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
        height: 91,
        decoration: BoxDecoration(
          color: itmGreyColor,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: Hero(
                  tag: "produce_bag_${widget.id!}",
                  child: Image.asset(
                    "assets/images/basket_4x.png",
                    width: 57,
                    height: 39,
                    fit: BoxFit.cover,
                  ),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.storeProduceBag!.produceBagTitle}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    '${widget.storeProduceBag!.produceBagProduct!.length} items',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CacheImage(
                            url:
                                "${MJ_Apis.APP_BASE_URL}${widget.storeProduceBag!.store!.storeIcon}",
                            height: 18,
                            width: 18,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${widget.storeProduceBag!.store!.storeName}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
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
                '\$${widget.storeProduceBag!.price}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
