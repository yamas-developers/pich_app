// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:farmer_app/Ui/order_details/orderDetailsSecond.dart';
import 'package:farmer_app/Ui/vouchers/voucher/voucher_area_selectable.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:provider/provider.dart';

class SelectVouchers extends StatefulWidget {
  static const String routeName = "/select_voucher";

  const SelectVouchers({Key? key}) : super(key: key);

  @override
  State<SelectVouchers> createState() => _SelectVouchersState();
}

class _SelectVouchersState extends State<SelectVouchers> {
  bool isPortrait = true;

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Consumer<CartHelper>(builder: (key, provider, widget) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/icons/back-arrow.png",
                            height: 25,
                          )),
                      Expanded(
                        child: Center(
                          child: const Text(
                            "Select Vouchers",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 0, 10),
                    child: Row(
                      children: [
                        const Text(
                          "Voucher Amount Required",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 72,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(19),
                      color: kprimaryColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Order Amount",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  "Select a voucher worth this or more",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              height: 60,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: kYellowColor,
                                  borderRadius: BorderRadius.circular(19)),
                              child: Center(
                                child: Text(
                                  "\$${provider.cartTotal}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const Text(
                          "Available Vouchers",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
VoucherAreaSelectable(key: UniqueKey(),),
                  // Container(
                  //   height: 100,
                  //   padding: EdgeInsets.all(10),
                  //   margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage(
                  //           "assets/icons/grey_background.png",
                  //         ),
                  //         fit: BoxFit.fill),
                  //   ),
                  //   child: Row(
                  //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.fromLTRB(
                  //             isPortrait ? 60 : 120, 15, 0, 10),
                  //         child: Column(
                  //           // mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   "Expiry",
                  //                   style: TextStyle(fontSize: 15),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 5,
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   "12 July 2022",
                  //                   style: TextStyle(
                  //                       fontSize: 13, color: kGreyColor),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       Padding(
                  //         padding:
                  //             EdgeInsets.only(right: isPortrait ? 30.0 : 50),
                  //         child: Text(
                  //           "\$50.00",
                  //           style: TextStyle(
                  //               color: kprimaryColor,
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.w600),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Stack(
                  //     alignment: Alignment.centerRight,
                  //     children: [
                  //   Container(
                  //     height: 100,
                  //     padding:
                  //         EdgeInsets.fromLTRB(isPortrait ? 60 : 120, 10, 10, 0),
                  //     margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //     decoration: BoxDecoration(
                  //       image: DecorationImage(
                  //           image: AssetImage(
                  //             "assets/icons/background.png",
                  //           ),
                  //           fit: BoxFit.fill),
                  //     ),
                  //     child: Row(
                  //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //       children: [
                  //         Padding(
                  //           padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  //           child: Column(
                  //             // mainAxisAlignment: MainAxisAlignment.center,
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Row(
                  //                 children: [
                  //                   Text(
                  //                     "Expiry",
                  //                     style: TextStyle(fontSize: 15),
                  //                   ),
                  //                 ],
                  //               ),
                  //               SizedBox(
                  //                 height: 5,
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   Text(
                  //                     "12 July 2022",
                  //                     style: TextStyle(
                  //                         fontSize: 13, color: kGreyColor),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //         Spacer(),
                  //         Padding(
                  //           padding:
                  //               EdgeInsets.only(right: isPortrait ? 30.0 : 50),
                  //           child: Text(
                  //             "\$50.00",
                  //             style: TextStyle(
                  //                 color: kprimaryColor,
                  //                 fontSize: 20,
                  //                 fontWeight: FontWeight.w600),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   CircleAvatar(
                  //     backgroundColor: kprimaryColor,
                  //     radius: 11,
                  //     child: Image.asset(
                  //       "assets/icons/tick.png",
                  //       height: 9,
                  //     ),
                  //   ),
                  // ]),
                  // Container(
                  //   height: 100,
                  //   padding: EdgeInsets.all(10),
                  //   margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         image: AssetImage(
                  //           "assets/icons/grey_background.png",
                  //         ),
                  //         fit: BoxFit.fill),
                  //   ),
                  //   child: Row(
                  //     // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Padding(
                  //         padding: EdgeInsets.fromLTRB(
                  //             isPortrait ? 60 : 120, 15, 0, 10),
                  //         child: Column(
                  //           // mainAxisAlignment: MainAxisAlignment.center,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   "Expiry",
                  //                   style: TextStyle(fontSize: 15),
                  //                 ),
                  //               ],
                  //             ),
                  //             SizedBox(
                  //               height: 5,
                  //             ),
                  //             Row(
                  //               children: [
                  //                 Text(
                  //                   "12 July 2022",
                  //                   style: TextStyle(
                  //                       fontSize: 13, color: kGreyColor),
                  //                 ),
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       Padding(
                  //         padding:
                  //             EdgeInsets.only(right: isPortrait ? 30.0 : 50),
                  //         child: Text(
                  //           "\$50.00",
                  //           style: TextStyle(
                  //               color: kprimaryColor,
                  //               fontSize: 20,
                  //               fontWeight: FontWeight.w600),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),

                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 56,
                  //   child: FlatButton(
                  //     color: Colors.black,
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16)),
                  //     onPressed: () {
                  //       Navigator.pushNamed(
                  //           context, orderDetailsSecond.routeName);
                  //     },
                  //     child: Text(
                  //       "Get More Vouchers",
                  //       style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.w500),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 120,
                  // ),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FlatButton(
                      color: kYellowColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
