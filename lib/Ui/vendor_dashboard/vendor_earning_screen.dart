import 'package:farmer_app/Ui/app_components/app_color_button.dart';
import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_wallet_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/order_data.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';

class VendorEarningScreen extends StatefulWidget {
  static const String routeName = "/vendor_earning_screen";

  const VendorEarningScreen({Key? key}) : super(key: key);

  @override
  State<VendorEarningScreen> createState() => _VendorEarningScreenState();
}

class _VendorEarningScreenState extends State<VendorEarningScreen> {
  String? voucherTotal;
  String? orderTotal;
  String? totalEarning;
  List<OrderData>? orders;
  bool isLoading = false;

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  User? user;

  getPageData() async {
    setState(() {
      isLoading = true;
    });
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    Store currentStore = context.read<VendorStoreProvider>().currentStore!;

    var response = await MjApiService().getRequest(
        MJ_Apis.get_store_earning + "/${user!.id}" + "/${currentStore.id}");
    print('earning: $response');
    List<OrderData>? list = <OrderData>[];
    if (response['orders'] != null) {
      response['orders'].forEach((v) {
        list.add(new OrderData.fromJson(v));
      });
    }
    setState(() {
      orders = list;
      voucherTotal = response['voucher_total'].toString();
      orderTotal = response['order_total'].toString();
      totalEarning = response['total_earning'].toString();
      isLoading = false;
    });
  }

  submitWithdrawRequest() async {

    Store currentStore = context.read<VendorStoreProvider>().currentStore!;
    // withdraw_request
    showProgressDialog(context, MJConfig.please_wait);
    var response = await MjApiService().getRequest(
        MJ_Apis.withdraw_request + "/${user!.id}" + "/${currentStore.id}");
    hideProgressDialog(context);
    List<OrderData>? list = <OrderData>[];
    if (response['orders'] != null) {
      showAlertDialog(
          context, "Request Submitted", "Request Submitted Successfully",
          type: AlertType.SUCCESS, dismissible: true);
      response['orders'].forEach((v) {
        list.add(new OrderData.fromJson(v));
      });
    }
    setState(() {
      orders = list;
      voucherTotal = response['voucher_total'].toString();
      orderTotal = response['order_total'].toString();
      totalEarning = response['total_earning'].toString();
      isLoading = false;
    });
  }

  bool isPortrait = true;

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    if (orders != null && orders!.isNotEmpty)
      print("earning_screen: ${orders![0].orderVoucher!.length}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/icons/arrow-left.png',
                              color: Colors.black,
                              scale: 10,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Earnings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),
                    TextButton(child: Text("Wallet"),onPressed: (){
                      Navigator.pushNamed(context, VendorWalletScreen.routeName);
                    },)
                  ],
                ),
              ),
            ),
            Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Card(
                          elevation: 8,
                          borderOnForeground: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: itmGreyColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Earnings Summary",
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
                                      "Orders Total:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    Text('\$${orderTotal ?? 0}',
                                        style: TextStyle(
                                          color: kprimaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ))
                                  ],
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Vouchers Total:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "\$${voucherTotal ?? 0}",
                                      style: TextStyle(
                                        color: kprimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Earnings:",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    Text('\$${totalEarning ?? 0}',
                                        style: TextStyle(
                                          color: kprimaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 40,
                                    // width: 100,
                                    child: TouchableOpacity(
                                      onTap: isLoading ? null : () {

                                        if(orders!.length < 1) {
                                          showAlertDialog(
                                              context,
                                              "Unable to request",
                                              "You do not have any orders yet",
                                              type: AlertType.ERROR,
                                              // okButtonText: "Continue",
                                              // onPress: () {
                                              //   Navigator.of(context).pop();
                                              //   submitWithdrawRequest();
                                              // },
                                              dismissible: true);
                                        }else{

                                        showAlertDialog(
                                            context,
                                            "Are you sure?",
                                            "Click continue if you want to submit withdraw request",
                                            type: AlertType.INFO,
                                            okButtonText: "Continue",
                                            onPress: () {
                                          Navigator.of(context).pop();
                                          submitWithdrawRequest();
                                        }, dismissible: true);
                                        }
                                      },
                                      child: AppColorButton(
                                        elevation: 0,
                                        name: "Withdraw Amount",
                                        color: isLoading ? Colors.blueGrey:kprimaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Divider(),
                      isLoading
                          ? Container(
                          height: getHeight(context) * .50,
                          child: Center(child: AppLoader()))
                          : Column(
                        children: [
                          if (orders!.isEmpty)
                            Column(
                              children: [
                                SizedBox(
                                  height: 60,
                                ),
                                emptyWidget(description: "No orders yet!"),
                              ],
                            ),
                          if(orders!.length >0)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Text(
                                "Pending Payment Orders",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ...orders!.map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  color: itmGreyColor),
                              padding: const EdgeInsets.all(10.0),
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
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   "",
                                      //   style: TextStyle(
                                      //     color: Colors.black54,
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w500,
                                      //   ),
                                      // ),
                                      // Spacer(),
                                      Badge(
                                        value: 'Order# ${e.id}',
                                        color: kprimaryColor,
                                        // child: Text('${e.id}',
                                        //     style: TextStyle(
                                        //       color: kprimaryColor,
                                        //       fontWeight: FontWeight.w600,
                                        //       fontSize: 14,
                                        //     )),
                                      )
                                    ],
                                  ),
                                  Divider(),
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
                                      Text(
                                        "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(e.createdAt!))}",
                                        style: TextStyle(
                                          color: kprimaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
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
                                      Text('${e.orderStatus}',
                                          style: TextStyle(
                                            color: kprimaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ))
                                    ],
                                  ),
                                  Divider(),
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 6),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Vouchers ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Badge(
                                          value: "${e.orderVoucher!.length}",
                                          color: kprimaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (e.orderVoucher!.isEmpty)
                                    Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Text(
                                            'No vouchers are included',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                  Wrap(
                                    // crossAxisAlignment: WrapCrossAlignment.start,
                                    // direction: Axis.horizontal,
                                    children: [
                                      ...e.orderVoucher!.map(
                                            (e) => Container(
                                          width: 130,
                                          // height: 44,
                                          // padding:
                                          // EdgeInsets.fromLTRB(isPortrait ? 10 : 10, 00, 0, 5),
                                          margin:
                                          EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                  "assets/icons/background.png",
                                                ),
                                                fit: BoxFit.fill),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Column(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    "Used",
                                                    style:
                                                    TextStyle(fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              // Spacer(),
                                              Text(
                                                "\$${e.voucherPrice}",
                                                style: TextStyle(
                                                    color: kprimaryColor,
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
