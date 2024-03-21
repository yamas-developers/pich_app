import 'package:date_format/date_format.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/home_produces/single_item_cart.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:flutter/material.dart';

import '../../helpers/color_constants.dart';

class HomeProduceItem  extends StatefulWidget {
  int? id;
  StoreProduct? storeProduct;
  HomeProduceItem ({required this.id, required this.storeProduct});

  @override
  State<HomeProduceItem > createState() => _HomeProduceItemState();
}

class _HomeProduceItemState extends State<HomeProduceItem > {
  @override
  Widget build(BuildContext context) {
    // print(widget.id!);
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => SingleItem(
              id: "produce_"+widget.id!.toString(), storeProduct: widget.storeProduct,
            ),
          ),
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
                  tag: "produce_${widget.id!}",
                  child: CacheImage(
                    url:"${MJ_Apis.APP_BASE_URL}${widget.storeProduct!.products!.iconImage}",
                    width: 56,
                    height: 56,
                    fit: BoxFit.contain,

                  ),
                )),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.storeProduct!.products!.productName}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    '${widget.storeProduct!.size}',
                    style: TextStyle(fontSize: 10),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          maxRadius: 11,
                          backgroundColor: Color.fromRGBO(249, 178, 51, 1),
                          child: CacheImage(
                            url:'${MJ_Apis.APP_BASE_URL}${widget.storeProduct!.store!.storeIcon}',
                            height: 11,
                            width: 11,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${widget.storeProduct!.store!.storeName}",
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
                '\$${widget.storeProduct!.price}',
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
