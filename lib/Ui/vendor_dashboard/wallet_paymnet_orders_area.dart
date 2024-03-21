import 'package:farmer_app/Ui/app_components/shimmer_ui/post_comment_list_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/user_order_list_shimmer.dart';
import 'package:farmer_app/Ui/orders/user/order_user_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/order_data.dart';
import 'package:farmer_app/models/payment_request_data.dart';
import 'package:farmer_app/providers/order/user_order_provider.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WalletPaymentOrdersArea extends StatefulWidget {
  const WalletPaymentOrdersArea(
      {Key? key, required this.userId, required this.request_id})
      : super(key: key);
  final String userId;
  final String request_id;

  @override
  State<WalletPaymentOrdersArea> createState() =>
      _WalletPaymentOrdersAreaState();
}

class _WalletPaymentOrdersAreaState extends State<WalletPaymentOrdersArea> {
  RefreshController _refreshController = RefreshController();
  bool isLoading = false;
  PaymentRequest? paymentRequest;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => getPageData());
    super.initState();
  }

  getPageData() async {
    getOrdersData();
  }

  Future<bool> getOrdersData() async {
    setState(() {
      isLoading = true;
    });

    var response = await MjApiService().getRequest(
        MJ_Apis.get_request_orders + "/${widget.userId}/${widget.request_id}");
    print('paymentOrderResponse: ${response["payment_"]}');

    if (response != null) {
      paymentRequest = PaymentRequest.fromJson(response);
    }
    setState(() {
      isLoading = false;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 8,
        ),
        isLoading
            ? SizedBox(
                height: getHeight(context), child: UserOrderListShimmer())
            : paymentRequest == null
                ? emptyWidget(description: "Unable to find orders")
                : paymentRequest!.paymentRequestOrder!.length < 1
                    ? emptyWidget(description: "Unable to find orders")
                    : Column(
                        children: List.generate(
                          paymentRequest!.paymentRequestOrder!.length,
                          (index) {
                            print(
                                'orderData in sheet: ${paymentRequest!.toJson()}');
                            return Column(
                              children: [
                                paymentRequest!.paymentRequestOrder![index]
                                            .order ==
                                        null
                                    ? Container(
                                        child: Text("null order"),
                                      )
                                    : Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: OrderUserItem(
                                          orderData: paymentRequest!
                                              .paymentRequestOrder![index]
                                              .order!
                                              .first,
                                          isPaymentRequestOrder: true,
                                        ),
                                    ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
        // SizedBox(height: 140),
      ],
    );
    // return SingleChildScrollView(
    //   child: Column(
    //     children: List.generate(10, (index) => OrderUserItem()),
    // ));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
