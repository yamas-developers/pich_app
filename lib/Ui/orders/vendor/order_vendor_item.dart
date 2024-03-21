import 'package:farmer_app/Ui/order_details/OrderDetails.dart';
import 'package:flutter/material.dart';

import '../../../helpers/color_constants.dart';

class OrderVendorItem extends StatefulWidget {
  const OrderVendorItem({Key? key}) : super(key: key);

  @override
  State<OrderVendorItem> createState() => _OrderVendorItemState();
}

class _OrderVendorItemState extends State<OrderVendorItem> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
        Navigator.pushNamed(
            context, OrderDetails.routeName);
      },
      child: Column(
        children: [
          Container(
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
                                "Order ID 76372",
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
                                "Fruit Food Box",
                                style:
                                TextStyle(fontSize: 13),
                              ),
                              SizedBox(width: 3),
                              Text(
                                "\$17.54",
                                style: TextStyle(
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
                                "Vouchers",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "\$10.00",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w500,
                                    color: kprimaryColor),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "\$10.00",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                    FontWeight.w500,
                                    color: kprimaryColor),
                              ),
                            ],
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
                Row(
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 12.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                kYellowColor,
                                child: Image.asset(
                                    "assets/icons/vendor.png",
                                    height: 17),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Wali Vendor",
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
                          Row(
                            children: [
                              Image.asset(
                                "assets/images/delievery.png",
                                height: 20,
                              ),
                              Text(
                                "12 Jan 2022",
                                style:
                                TextStyle(fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
