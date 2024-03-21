import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/Ui/order_details/OrderDetails.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/models/order_data.dart';
import 'package:farmer_app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../helpers/color_constants.dart';

class OrderUserItem extends StatefulWidget {
  const OrderUserItem({Key? key, required this.orderData, this.callBack, this.isPaymentRequestOrder = false}) : super(key: key);
final  callBack;
  final OrderData orderData;
  final bool isPaymentRequestOrder;

  @override
  State<OrderUserItem> createState() => _OrderUserItemState();
}

class _OrderUserItemState extends State<OrderUserItem> {
  int voucherTotalAmount = 0;
  // Store store = Store();

  @override
  void initState() {
    getPageData();

    super.initState();
  }

  getPageData() async {
    // var response = await MjApiService()
    //     .getRequest(MJ_Apis.get_store_by_id + "/${widget.orderData.storeId}");
    // if(response!=null)setState(() {
    //   store = Store.fromJson(response);
    // });
    int voucherTotal = 0;
    widget.orderData.orderVoucher!.forEach((e){
      voucherTotal += e.voucherPrice ?? 0;
    });
    setState(() {
      voucherTotalAmount = voucherTotal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () async {
        var result = await Navigator.pushNamed(
            context, OrderDetails.routeName, arguments: {"orderData":widget.orderData});
        if(result == true){
          // widget.callBack();
        }
      },
      child: Container(
        height: 135,
        margin: EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
            color: kGrey,
            borderRadius: BorderRadius.circular(19)),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Order ID ${widget.orderData.id}",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/bag.png",
                            height: 21,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "${widget.orderData.orderProduce!.length + widget.orderData.orderProduct!.length} Item(s)",
                            style:
                            TextStyle(fontSize: 14),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "\$${widget.orderData.total}",
                            style: TextStyle(
                              fontSize: 16,
                                color: kprimaryColor),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Vouchers Total:",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "\$${voucherTotalAmount}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                FontWeight.w500,
                                color: kprimaryColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 6,),
                      Badge(
                        value: '${widget.orderData.orderStatus}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
              child: Divider(
                thickness: 2,
                height: 2,
                color: kdividershade,
                indent: 20,
                endIndent: 20,
              ),
            ),
            if(widget.orderData.store!= null && !widget.isPaymentRequestOrder)Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(left: 12.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor:
                            kYellowColor,
                            child: Image.asset(
                                "assets/icons/vendor.png",
                                height: 13),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "${widget.orderData.store!.storeName ?? 'Store unavailable'}",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                FontWeight.w500),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(
                                top: 3.0),
                            child: Image.asset(
                              "assets/icons/angular.png",
                              height: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 12.0),
                  child: Column(
                    children: [
                      Text(
                        "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(widget.orderData.createdAt!))}",
                        style:
                        TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            )
            else Padding(
              padding: const EdgeInsets.fromLTRB(12,8,12,0),
              child: Row(
                children: [
                  Text(
                    "Click to view details > ",
                    style: TextStyle(
                        fontSize: 13,
                        color: kprimaryColor,
                        fontWeight:
                        FontWeight.w500),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Text(
                        "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(widget.orderData.createdAt!))}",
                        style:
                        TextStyle(fontSize: 12),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
