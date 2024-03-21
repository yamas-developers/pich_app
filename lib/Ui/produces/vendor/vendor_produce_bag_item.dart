import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/produces/vendor/add_vendor_produce.dart';
import 'package:farmer_app/Ui/produces/vendor/edit_vendor_produces.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:flutter/material.dart';

import '../../../helpers/color_constants.dart';

class VendorProduceBagItem extends StatefulWidget {
  VendorProduceBagItem(
      {Key? key,
      this.storeProduce,
      required this.actionTitle,
      required this.actionCallback,
      this.onTap = null, this.id = ''})
      : super(key: key);
  StoreProduceBag? storeProduce;
  String actionTitle;
  String id;
  final actionCallback;
  final onTap;

  @override
  State<VendorProduceBagItem> createState() => _VendorProduceBagItemState();
}

class _VendorProduceBagItemState extends State<VendorProduceBagItem> {
  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 4, 10, 4),
        padding: EdgeInsets.all(2),
        height: 101,
        decoration: BoxDecoration(
          color: kGreyColor,
          borderRadius: BorderRadius.circular(19),
        ),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(18.0),
                child: Hero(
                  tag: widget.id,
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
                    "${widget.storeProduce!.produceBagTitle}",
                    style: TextStyle(
                        fontSize: 15, color: Theme.of(context).primaryColor),
                  ),
                  if (widget.storeProduce!.produceBagProduct != null)
                    Text(
                      '${widget.storeProduce!.produceBagProduct!.length} items',
                      style: TextStyle(fontSize: 10),
                    ),
                  SizedBox(height: 3,),
                  Badge(
                    value: '${widget.storeProduce!.status}',
                    color: kprimaryColor,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    // SizedBox(width: 5),
                    child: Text(
                      '\$${widget.storeProduce!.price}',
                      style: TextStyle(fontSize: 15, color: kprimaryColor),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.actionTitle != '')
              GestureDetector(
                onTap: widget.actionCallback,
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
                          "${widget.actionTitle}",
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
