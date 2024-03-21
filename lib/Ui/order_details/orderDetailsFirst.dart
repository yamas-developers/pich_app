// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/other_vendor_store_list_shimmer.dart';
import 'package:farmer_app/Ui/vouchers/selectVouchers.dart';
import 'package:farmer_app/Ui/vouchers/voucher/voucher_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_voucher.dart';
import 'package:farmer_app/providers/store/home_store_list_provider.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:farmer_app/providers/voucher/user_voucher_provider.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:provider/provider.dart';

import '../home_screen.dart';

class orderDetailsFirst extends StatefulWidget {
  static const String routeName = "/order_details_first";

  const orderDetailsFirst({Key? key}) : super(key: key);

  @override
  State<orderDetailsFirst> createState() => _orderDetailsFirstState();
}

class _orderDetailsFirstState extends State<orderDetailsFirst> {
  User? user;
  Store store = Store();
  bool loading = false;

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  getPageData() async {
    User? userData = context.read<UserProvider>().currentUser;
    setState(() {
      user = userData;
      loading = true;
    });
    var storeId = context.read<CartHelper>().list.first.storeId;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_store_by_id + "/${storeId}");
    if (response != null)
      setState(() {
        store = Store.fromJson(response);
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Consumer<CartHelper>(builder: (key, provider, widget) {
          return Consumer<UserVoucherProvider>(
              builder: (key, voucherProvider, widget) {
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
                              "Order Confirmation",
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
                            "Store Details",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    if(loading)OtherVendorStoreShimmerItem()
                    else Container(
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: kprimaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kRedColor,
                                  radius: 22,
                                  child: Image.asset(
                                    "assets/icons/vendor.png",
                                    height: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${store.storeName}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      // height: 25,
                                      width: 200,
                                      child: Text(
                                        "${store.address}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Image.asset(
                                  "assets/icons/location_icon.png",
                                  height: 20,
                                )
                              ],
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
                            "Order Details",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: kGrey,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "${provider.storeProduceBagList.length} Food Box(es)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: kprimaryColor,
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
                                      padding:
                                          const EdgeInsets.only(bottom: 3.0),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/bag.png",
                                            height: 25,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("${e.qty}x ${e.produceBagTitle}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)),
                                          Spacer(),
                                          Text(
                                            "\$${convertDoublePoints(convertDouble(e.price.toString()))}",
                                            style: TextStyle(
                                                color: kprimaryColor,
                                                fontWeight: FontWeight.w600),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList()),
                          if (provider.storeProductList.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Text(
                                    "${provider.storeProductList.length} Single Items",
                                    style: TextStyle(
                                      color: kprimaryColor,
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
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          CacheImage(
                                            url:
                                                "${MJ_Apis.APP_BASE_URL}${e.products!.iconImage}",
                                            height: 30,
                                          ),
                                          // Image.asset(
                                          //   "assets/icons/pear.png",
                                          //
                                          // ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            "${e.qty}x ${e.products!.productName}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Spacer(),

                                          Text(
                                            "${e.size}",
                                            style: TextStyle(
                                                color: kprimaryColor,
                                                fontSize: 13),
                                          ),
                                          // SizedBox(width: 20,),
                                          Text(
                                            " (\$${e.price})",
                                            style: TextStyle(
                                                color: kprimaryColor,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList()),
                        ],
                      ),
                    ),

                    // Column(
                    //   children: [
                    //     Container(
                    //       height: 290,
                    //       decoration: BoxDecoration(
                    //         color: kGrey,
                    //         borderRadius: BorderRadius.circular(19),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(18.0),
                    //         child: Column(
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 Image.asset("assets/images/bag.png", height: 35,),
                    //                 const SizedBox(width: 10,),
                    //                 const Text("1x Fruit Produces",
                    //                     style:TextStyle(
                    //                         fontSize: 15,
                    //                         fontWeight: FontWeight.w500
                    //                     )),
                    //                 const Spacer(),
                    //                 const Text("\$17.54", style: TextStyle(
                    //                     color: kprimaryColor,
                    //                     fontWeight: FontWeight.w600
                    //                 ),)
                    //               ],
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 10.0),
                    //               child: Row(
                    //                 children: [
                    //                   const Text("5 items",
                    //                     style: TextStyle(
                    //                       color: kYellowColor,
                    //                       fontWeight: FontWeight.w600,
                    //                       fontSize: 15,
                    //                     ),)
                    //                 ],
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 8.0),
                    //               child: Row(
                    //                 children: [
                    //                   Image.asset("assets/icons/pear.png",height: 30,),
                    //                   const SizedBox(
                    //                     width: 6,
                    //                   ),
                    //                   const Text("Pear",
                    //                     style: TextStyle(
                    //                         fontSize: 15,
                    //                         fontWeight: FontWeight.w500
                    //                     ),),
                    //                   const Spacer(),
                    //                   const Text("500g",
                    //                     style: TextStyle(
                    //                         color: kprimaryColor,
                    //                         fontSize: 13
                    //                     ),)
                    //                 ],
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 8.0),
                    //               child: Row(
                    //                 children: [
                    //                   Image.asset("assets/icons/lemon.png",height: 19,),
                    //                   const SizedBox(
                    //                     width: 6,
                    //                   ),
                    //                   const Text("Lemon",
                    //                     style: const TextStyle(
                    //                         fontSize: 15,
                    //                         fontWeight: FontWeight.w500
                    //                     ),),
                    //                   const Spacer(),
                    //                   const Text("250g",
                    //                     style: TextStyle(
                    //                         color: kprimaryColor,
                    //                         fontSize: 13
                    //                     ),)
                    //                 ],
                    //               ),
                    //             ),
                    //             Padding(
                    //               padding: const EdgeInsets.only(top: 8.0),
                    //               child: Row(
                    //                 children: [
                    //                   Image.asset("assets/icons/grape.png",height: 30,),
                    //                   const SizedBox(
                    //                     width: 6,
                    //                   ),
                    //                   const Text("Grape",
                    //                     style: TextStyle(
                    //                         fontSize: 15,
                    //                         fontWeight: FontWeight.w500
                    //                     ),),
                    //                   const Spacer(),
                    //                   const Text("500g",
                    //                     style: const TextStyle(
                    //                         color: kprimaryColor,
                    //                         fontSize: 13
                    //                     ),)
                    //                 ],
                    //               ),
                    //             ),  Padding(
                    //               padding: const EdgeInsets.only(top: 8.0),
                    //               child: Row(
                    //                 children: [
                    //                   Image.asset("assets/icons/watermelon.png",height: 30,),
                    //                   const SizedBox(
                    //                     width: 6,
                    //                   ),
                    //                   const Text("Watermelon",
                    //                     style: TextStyle(
                    //                         fontSize: 15,
                    //                         fontWeight: FontWeight.w500
                    //                     ),),
                    //                   const Spacer(),
                    //                   const Text("Medium",
                    //                     style: const TextStyle(
                    //                         color: kprimaryColor,
                    //                         fontSize: 13
                    //                     ),)
                    //                 ],
                    //               ),
                    //             ),  Padding(
                    //               padding: const EdgeInsets.only(top: 8.0),
                    //               child: Row(
                    //                 children: [
                    //                   Image.asset("assets/images/banana.png",height: 30,),
                    //                   const SizedBox(
                    //                     width: 6,
                    //                   ),
                    //                   const Text("Banana",
                    //                     style: const TextStyle(
                    //                         fontSize: 15,
                    //                         fontWeight: FontWeight.w500
                    //                     ),),
                    //                   const Spacer(),
                    //                   const Text("6",
                    //                     style: TextStyle(
                    //                         color: kprimaryColor,
                    //                         fontSize: 13
                    //                     ),)
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Vouchers",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          if (voucherProvider.selectedVouchersList.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, SelectVouchers.routeName);
                              },
                              child: Text(
                                "Select vouchers worth \$${provider.cartTotal}",
                                style: TextStyle(
                                    color: kprimaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                        ],
                      ),
                    ),
                    voucherProvider.selectedVouchersList.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SelectVouchers.routeName);
                            },
                            child: Column(
                                children: voucherProvider.selectedVouchersList
                                    .map((e) => VoucherItem(
                                          voucherData: e,
                                          onClose: () {
                                            voucherProvider
                                                .unselectVoucher(e.id);
                                          },
                                          showOnclose: true,
                                        ))
                                    .toList()),
                          )
                        : Container(
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      "assets/icons/dotted_border.png"),
                                  fit: BoxFit.fill),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SelectVouchers.routeName);
                                  },
                                  child: Text(
                                    "Select vouchers worth \$${provider.cartTotal}",
                                    style: TextStyle(
                                        color: kprimaryColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 70,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FlatButton(
                        color: kYellowColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onPressed: () async {
                          //submit order

                          if(voucherProvider.selectedVoucherTotal < 1){
                            showToast('You haven\'t selected vouchers for your order');
                            return;
                          }
                          if(voucherProvider.selectedVoucherTotal < provider.cartTotal){
                            showToast('You haven\'t selected vouchers enough for your current order');
                            return;
                          }

                          Map payload = {
                            'produces': jsonEncode(provider.storeProduceBagList
                                .map((e) => e.toJson())
                                .toList()),
                            'products': jsonEncode(provider.storeProductList
                                .map((e) => e.toJson())
                                .toList()),
                            'vouchers': jsonEncode(voucherProvider
                                .selectedVouchersList
                                .map((e) => e.id)
                                .toList())
                          };

                          print('payload: ${payload['vouchers']}');
                          showProgressDialog(context, 'Submitting Order',
                              isDismissable: false);

                          var response = await MjApiService().simplePostRequest(
                              MJ_Apis.submit_order + "/${user!.id}", payload);
                          hideProgressDialog(context);
                          if (response != null) {
                            provider.clearCart();
                            provider.getCartData();
                            voucherProvider.selectedVouchersList = [];

                            showAlertDialog(context, "Successful",
                                "Order placed successfully",
                                okButtonText: "Go to Home", onPress: () {
                              Navigator.popUntil(
                                  context,
                                  (route) =>
                                      route.settings.name ==
                                      HomeScreen.routeName);
                            },showCancelButton: false,type: AlertType.SUCCESS, dismissible: false);
                          }
                        },
                        child: Text(
                          "Submit Order \$${provider.cartTotal}",
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
          });
        }),
      ),
    );
  }
}
