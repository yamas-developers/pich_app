// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/order_details/orderDetailsFirst.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:provider/provider.dart';

class UserCartScreen extends StatefulWidget {
  static const String routeName = "/user_cart";

  UserCartScreen({Key? key}) : super(key: key);

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  bool isPortrait = true;
  User user = User();

  getPageData() async {
    user = (await getUser())!;
    context.read<CartHelper>().getCartData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();
  }

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
          print('loadingCart: ${provider.loading}');
          return Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Image.asset(
                          "assets/icons/back-arrow.png",
                          height: 25,
                        )),
                    Text(
                      "Cart",
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      // height: 38,
                      // width: 88,
                      child: (provider.loading)
                          ? ColorCircularProgressIndicator(
                              showMessage: false,
                              height: 28,
                              width: 28,
                              stroke: 4,
                            )
                          : provider.list.isNotEmpty
                              ? TextButton(
                                  onPressed: () async {
                                    await provider.clearCart();
                                  },
                                  child: Text(
                                    "Clear Cart",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              : Container(),
                    )
                  ],
                ),

                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20,30,0,10),
                //   child: Row(
                //     children: [
                //       Text("Store Details",
                //       style: TextStyle(
                //         fontSize: 15,
                //         color: Colors.black,
                //         fontWeight: FontWeight.w500
                //       ),),
                //     ],
                //   ),
                // ),
                // Container(
                //   height: 72,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(19),
                //     color: kprimaryColor,
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                //     child: Row(
                //       children: [
                //         CircleAvatar(
                //           backgroundColor: kRedColor,
                //           radius: 25,
                //           child: Image.asset("assets/icons/vendor.png",height: 22,),
                //         ),
                //         SizedBox(
                //           width: 6,
                //         ),
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text("Billy Vendor", style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 15,
                //               fontWeight: FontWeight.w500,
                //             ),),
                //             Text("Main Street Downtown",
                //             style: TextStyle(
                //               color: Colors.white,
                //               fontSize: 12
                //             ),),
                //           ],
                //         ),
                //         Spacer(),
                //         Image.asset("assets/icons/location_icon.png", height: 25,)
                //       ],
                //     ),
                //   ),
                // ),
                //      Padding(
                //        padding: const EdgeInsets.all(20.0),
                //        child: Row(
                //          // mainAxisAlignment: MainAxisAlignment.end,
                //          children: [
                //            Text("Order Details",
                //            style: TextStyle(
                //              color: Colors.black,
                //              fontSize: 15,
                //              fontWeight: FontWeight.w500,
                //            ),
                //            ),
                //            Spacer(),
                //            Image.asset("assets/images/delievery.png", height: 20,),
                //            Text("12 Jan, 2022"),
                //          ],
                //        ),
                //      ),
                SizedBox(
                  height: 20,
                ),
                (provider.storeProductList.isEmpty &&
                        provider.storeProduceBagList.isEmpty &&
                        provider.loading)
                    ? SizedBox(
                        height: getHeight(context) - 200,
                        child: Center(child: AppLoader()))
                    : Column(
                        children: [
                          if (provider.storeProduceBagList.isNotEmpty)
                            Container(
                              // height: 290,
                              decoration: BoxDecoration(
                                color: kGrey,
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${provider.storeProduceBagList.length} Food Box(es)",
                                            style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                        children: provider.storeProduceBagList
                                            .map(
                                              (e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3.0),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/bag.png",
                                                            height: 23,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "${e.qty}x ${e.produceBagTitle}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Spacer(),
                                                    Container(
                                                      width: 70,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          // IconButton(padding: EdgeInsets.all(0), icon: Icon(Icons.add), onPressed: () {  },iconSize: 15,),
                                                          InkWell(
                                                            onTap: () {
                                                              provider.updateBagCartQuantity(
                                                                  e.cartId!,
                                                                  convertNumber(
                                                                          e.qty!) +
                                                                      1);
                                                              print(
                                                                  'cartID: ${e.cartId}');
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  kGreyColor,
                                                              maxRadius: 14,
                                                              child: Text(
                                                                '+',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                          ),
                                                          // CircleAvatar(
                                                          //   backgroundColor: Colors.grey,
                                                          //   child: Text('1'),),
                                                          // IconButton(padding: EdgeInsets.all(0), icon: Icon(Icons.minimize), onPressed: () {  },iconSize: 15,),
                                                          InkWell(
                                                            onTap: () {
                                                              provider.updateBagCartQuantity(
                                                                  e.cartId!,
                                                                  convertNumber(
                                                                          e.qty!) -
                                                                      1);
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  kGreyColor,
                                                              maxRadius: 14,
                                                              child: Text(
                                                                '-',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "\$${convertDoublePoints(convertDouble(e.price.toString()))}",
                                                      style: TextStyle(
                                                          color: kprimaryColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                            .toList()),
                                  ],
                                ),
                              ),
                            ),
                          if (provider.storeProductList.isNotEmpty)
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${provider.storeProductList.length} Single Item(s)",
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                    children: provider.storeProductList
                                        .map(
                                          (e) => Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    CacheImage(
                                                      url:
                                                          "${MJ_Apis.APP_BASE_URL}${e.products!.iconImage}",
                                                      height: 28,
                                                    ),
                                                    // Image.asset(
                                                    //   "assets/icons/pear.png",
                                                    //
                                                    // ),
                                                    SizedBox(
                                                      width: 6,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${e.qty}x ${e.products!.productName}",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          " (\$${e.price})",
                                                          style: TextStyle(
                                                              color:
                                                                  kprimaryColor,
                                                              fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      width: 70,
                                                      height: 32,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              provider.updateProductCartQuantity(
                                                                  e.cartId!,
                                                                  convertNumber(
                                                                          e.qty!) +
                                                                      1);
                                                              print(
                                                                  'cartID: ${e.cartId}');
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  kGreyColor,
                                                              maxRadius: 14,
                                                              child: Text(
                                                                '+',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              provider.updateProductCartQuantity(
                                                                  e.cartId!,
                                                                  convertNumber(
                                                                          e.qty!) -
                                                                      1);
                                                            },
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  kGreyColor,
                                                              maxRadius: 14,
                                                              child: Text(
                                                                '-',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        24,
                                                                    color: Colors
                                                                        .black54),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${e.size}",
                                                      style: TextStyle(
                                                          color: kprimaryColor,
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    // Spacer(),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList()),
                              ],
                            ),
                          if (provider.storeProductList.isEmpty &&
                              provider.storeProduceBagList.isEmpty)
                            Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                emptyWidget(),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (provider.storeProduceBagList.isNotEmpty ||
                              provider.storeProductList.isNotEmpty)
                            Container(
                                // height: 290,
                                decoration: BoxDecoration(
                                  color: kGrey,
                                  borderRadius: BorderRadius.circular(19),
                                ),
                                child: SizedBox(
                                  height: 200,
                                  width: getWidth(context),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: Text(
                                          "Cart Sumary",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CartSummaryItem(
                                          leading: 'Food Box(es): ',
                                          trailing:
                                              '${provider.storeProduceBagList.length}x'),
                                      CartSummaryItem(
                                          leading: 'Single Item(s): ',
                                          trailing:
                                              '${provider.storeProductList.length}x'),
                                      CartSummaryItem(
                                          leading: 'Cart Total: ',
                                          trailing: '\$${provider.cartTotal}'),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              orderDetailsFirst.routeName);
                                        },
                                        child: Text(
                                          'Proceed',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                        ],
                      ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 12),
                //   child: Container(
                //     height: 85,
                //     decoration: BoxDecoration(
                //         color: kGrey, borderRadius: BorderRadius.circular(19)),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Row(
                //             children: [
                //               Image.asset(
                //                 "assets/images/banana.png",
                //                 height: 45,
                //               ),
                //               SizedBox(
                //                 width: 12,
                //               ),
                //               Text(
                //                 "6x Banana's",
                //                 style: TextStyle(
                //                     fontSize: 15, fontWeight: FontWeight.w500),
                //               ),
                //               Spacer(),
                //               Text(
                //                 "\$10.56",
                //                 style: TextStyle(
                //                     color: kprimaryColor,
                //                     fontSize: 15,
                //                     fontWeight: FontWeight.w500),
                //               )
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                //   child: Row(
                //     children: [
                //       Text(
                //         "Vouchers",
                //         style: TextStyle(
                //             fontSize: 15,
                //             color: Colors.black,
                //             fontWeight: FontWeight.w500),
                //       ),
                //     ],
                //   ),
                // ),
                //
                // Column(
                //   children: [
                //     Stack(alignment: Alignment.centerRight, children: [
                //       Container(
                //         width: double.infinity,
                //         height: 100,
                //         padding: EdgeInsets.fromLTRB(
                //             isPortrait ? 60 : 120, 10, 10, 0),
                //         margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                //         decoration: BoxDecoration(
                //           image: DecorationImage(
                //               image: AssetImage(
                //                 "assets/icons/background.png",
                //               ),
                //               fit: BoxFit.fill),
                //         ),
                //         child: Row(
                //           children: [
                //             Padding(
                //               padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                //               child: Column(
                //                 // mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     "Expiry",
                //                     style: TextStyle(fontSize: 15),
                //                   ),
                //                   SizedBox(
                //                     height: 5,
                //                   ),
                //                   Text(
                //                     "12 July 2022",
                //                     style: TextStyle(
                //                         fontSize: 13, color: kGreyColor),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             Spacer(),
                //             Padding(
                //               padding: EdgeInsets.only(
                //                   right: isPortrait ? 30.0 : 50),
                //               child: Text(
                //                 "\$50.00",
                //                 style: TextStyle(
                //                     color: kprimaryColor,
                //                     fontSize: 20,
                //                     fontWeight: FontWeight.w600),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //       CircleAvatar(
                //         backgroundColor: kprimaryColor,
                //         radius: 11,
                //         child: Image.asset(
                //           "assets/icons/tick.png",
                //           height: 9,
                //         ),
                //       ),
                //     ]),
                //   ],
                // ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CartSummaryItem extends StatelessWidget {
  const CartSummaryItem({
    Key? key,
    required this.leading,
    required this.trailing,
  }) : super(key: key);
  final String leading;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        Text(
          leading,
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Spacer(),
        Text(
          trailing,
          style: TextStyle(
            color: kprimaryColor,
            // color: Colors.blueGrey,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
