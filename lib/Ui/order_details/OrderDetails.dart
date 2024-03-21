// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/order_details/orderDetailsFirst.dart';
import 'package:farmer_app/Ui/vouchers/voucher/voucher_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/order_data.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_voucher.dart';
import 'package:farmer_app/providers/order/user_order_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class OrderDetails extends StatefulWidget {
  static const String routeName = "/order_details";

  const OrderDetails({Key? key}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  OrderData? orderData;
  User? user = User();
  bool isVendor = false;

  // Store storeData = Store();

  @override
  void initState() {}

  @override
  void didChangeDependencies() {
    getPageData();
    super.didChangeDependencies();
  }

  getPageData() async {
    User _user = (await getUser())!;
    setState(() {
      user = _user;
    });
    bool _isVendor = user!.rolesId == VENDOR;
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    OrderData order = args["orderData"];
    setState(() {
      orderData = order;
      isVendor = _isVendor;
    });
  }

  changeOrderStatus(String status) async {
    if (status != 'Canceled' && status != 'Completed')
      return;
    else {
      showProgressDialog(context, 'Updating order status');
      dynamic response = await MjApiService()
          .postRequest(MJ_Apis.order_status+'/${orderData!.id}', {"order_status": "$status"});
      hideProgressDialog(context);
      if (response != null) {
        context.read<UserCurrentOrderProvider>().changeOrderStatus(orderData!.id!, status);
        context.read<UserPreviousOrderProvider>().changeOrderStatus(orderData!.id!, status);
        showToast('Successfully updated');
        Navigator.pop(context, true);
      }
    }
  }

  bool isPortrait = true;

  @override
  Widget build(BuildContext context) {
    if(orderData != null)print('orderID: ${orderData!.id}');
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: orderData == null ? Center(child: AppLoader(),):Column(
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
                      child: Text(
                        "Order Details",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
              if(orderData!.user != null || orderData!.store != null)Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 0, 10),
                child: Row(
                  children: [
                    if (isVendor && orderData!.user != null)
                      Text(
                        "User Details",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      )
                    else if(orderData!.store != null)
                      Text(
                        "Store Details",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              if (isVendor && orderData!.user != null)
                Container(
                  height: 82,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: kprimaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),

                              // backgroundColor: kRedColor,
                              // radius: 18,
                              child: CacheImage(
                                url:
                                    "${MJ_Apis.APP_BASE_URL}${orderData!.user!.profileImage}",
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    '${orderData!.user!.firstname} ${orderData!.user!.lastname}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // height: 25,
                                  width: 200,
                                  child: Text(
                                    "${orderData!.user!.email}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                                SizedBox(
                                  // height: 25,
                                  width: 200,
                                  child: Text(
                                    "${orderData!.user!.phoneNumber}",
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
                )
              else if(orderData!.store!= null)
                Container(
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
                              radius: 18,
                              child: Image.asset(
                                "assets/icons/vendor.png",
                                height: 18,
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${orderData!.store!.storeName}',
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
                                    "${orderData!.store!.address}",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Order id:",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text('${orderData!.id}',
                            style: TextStyle(
                              color: kprimaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ))
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Date:",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        if(orderData!.createdAt != null)Text(
                          "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(orderData!.createdAt!))}",
                          style: TextStyle(
                            color: kYellowColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
              Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Order status:",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Text('${orderData!.orderStatus}',
                            style: TextStyle(
                              color: kYellowColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ))
                      ],
                    )
                  ],
                ),
              ),
              if(orderData!.orderProduce!.length > 0)Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 8),
                    child: Text(
                      "Order's Food Box(es)",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    // height: 230,
                    decoration: BoxDecoration(
                      color: kGrey,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: orderData!.orderProduce!
                            .map((e) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/bag.png",
                                          height: 25,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("${e.quantity}x Food Box(es)",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w500)),
                                        Spacer(),
                                        Text(
                                          "\$${e.price}",
                                          style: TextStyle(
                                              color: kprimaryColor,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${e.produceProducts!.length} item(s)",
                                            style: TextStyle(
                                              color: kYellowColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    ...e.produceProducts!.map(
                                      (p) => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            CacheImage(
                                              url:
                                                  "${MJ_Apis.APP_BASE_URL}${p.product!.iconImage}",
                                              height: 30,
                                            ),
                                            SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              "${e.quantity}x ${p.product!.productName}",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black54),
                                            ),
                                            Spacer(),
                                            Text(
                                              "${p.productSize}",
                                              style: TextStyle(
                                                  color: kprimaryColor,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              " (\$${e.price})",
                                              style: TextStyle(
                                                  color: kprimaryColor,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
              if(orderData!.orderProduct!.length > 0)Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 8),
                      child: Text(
                        "Order's Single Item(s)",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      // height: 85,
                      decoration: BoxDecoration(
                          color: kGrey,
                          borderRadius: BorderRadius.circular(19)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: orderData!.orderProduct!
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CacheImage(
                                            url:
                                                "${MJ_Apis.APP_BASE_URL}${e.product!.iconImage}",
                                            height: 30,
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            "${e.quantity}x ${e.product!.productName}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Spacer(),
                                          Text(
                                            "\$${e.price}",
                                            style: TextStyle(
                                                color: kprimaryColor,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Divider(),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Row(
                  children: [
                    Text(
                      "Voucher(s)",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              if(orderData!.orderVoucher!.isEmpty)Text('No voucher(s) found', style: TextStyle(color: Colors.grey),),
              ...orderData!.orderVoucher!.map(
                (e) => Container(
                  width: double.infinity,
                  height: 100,
                  padding:
                      EdgeInsets.fromLTRB(isPortrait ? 60 : 120, 10, 10, 0),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          "assets/icons/background.png",
                        ),
                        fit: BoxFit.fill),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Used",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(orderData!.createdAt!))}",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding:
                            EdgeInsets.only(right: isPortrait ? 30.0 : 50),
                        child: Text(
                          "\$${e.voucherPrice}",
                          style: TextStyle(
                              color: kprimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isVendor &&
                  orderData!.orderStatus!.toLowerCase() != "canceled" &&
                  orderData!.orderStatus!.toLowerCase() != 'completed')
                Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TouchableOpacity(
                      onTap: () {
                        changeOrderStatus('Completed');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(19),
                          color: kprimaryColor,
                        ),
                        height: 60,
                        width: 250,
                        child: Center(
                            child: Text(
                          'Complete Order',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                        onPressed: () {
                          changeOrderStatus('Canceled');
                        },
                        child: Text(
                          'Cancel Order',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 10,
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
