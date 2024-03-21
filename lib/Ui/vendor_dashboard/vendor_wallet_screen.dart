import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/Ui/app_components/intro_slider.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/completed_payment_list_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/pending_request_item_shimmer.dart';
import 'package:farmer_app/Ui/orders/user/order_user_item.dart';
import 'package:farmer_app/Ui/vendor_dashboard/wallet_paymnet_orders_area.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/order_data.dart';
import 'package:farmer_app/models/payment_request_data.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/store/vendor_payment_request_provider.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VendorWalletScreen extends StatefulWidget {
  static const String routeName = "/vendor_wallet_screen";

  const VendorWalletScreen({Key? key}) : super(key: key);

  @override
  State<VendorWalletScreen> createState() => _VendorWalletScreenState();
}

class _VendorWalletScreenState extends State<VendorWalletScreen> {
  bool isLoading = false;

  RefreshController _refreshController = RefreshController();
  User? user = User();
  Store? currentStore;

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  getPageData() async {
    user = (await getUser())!;
    Store store = context.read<VendorStoreProvider>().currentStore!;
    setState(() {
      user = user;
      currentStore = store;
    });

    if (context == null) {
      await Future.delayed(Duration(milliseconds: 50));
      getPageData();
      return;
    }
    await getPaymentRequests();
  }

  reset() async {
    if (context == null) {
      await Future.delayed(Duration(milliseconds: 50));
      reset();
      return;
    }
    context.read<VendorPaymentRequestProvider>().currentPage = 0;
    context.read<VendorPaymentRequestProvider>().maxPages = 0;
    context.read<VendorPaymentRequestProvider>().completedRequests = [];
    // context.read<VendorPaymentRequestProvider>().pendingRequests = [];
    context.read<VendorPaymentRequestProvider>().isLoading = false;
    bool res = await getPaymentRequests();
    return res;
  }

  Future<bool> getPaymentRequests() async {
    context.read<VendorPaymentRequestProvider>().isLoading = true;

    var response = await MjApiService().getRequest(
        MJ_Apis.payment_request + "/${user!.id}/${currentStore!.id}");

    context.read<VendorPaymentRequestProvider>().isLoading = false;

    _refreshController.refreshCompleted();
    if (response != null) {
      List<PaymentRequest> pendingRequests = [];
      List<PaymentRequest> completedRequests = [];
      for (int i = 0; i < response['pending_requests'].length; i++) {
        pendingRequests
            .add(PaymentRequest.fromJson(response['pending_requests'][i]));
      }
      for (int i = 0; i < response['requests']["data"].length; i++) {
        completedRequests
            .add(PaymentRequest.fromJson(response['requests']['data'][i]));
      }
      context.read<VendorPaymentRequestProvider>().currentPage =
          response['requests']['current_page'];
      context.read<VendorPaymentRequestProvider>().maxPages =
          response['requests']['last_page'];
      context.read<VendorPaymentRequestProvider>().pendingRequests =
          pendingRequests;
      context.read<VendorPaymentRequestProvider>().completedRequests =
          completedRequests;
    }
    return true;
  }

  Future<bool> loadMorePaymentRequest() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<VendorPaymentRequestProvider>().currentPage + 1;
    if (page > context.read<VendorPaymentRequestProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }

    var response = await MjApiService().getRequest(MJ_Apis.payment_request +
        "/${user!.id}/${currentStore!.id}&page=${page}");

    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<PaymentRequest> Completedlist = [];
      // List<PaymentRequest> completedRequests = [];
      // for (int i = 0; i < response['pending_requests'].length; i++) {
      //   pendingRequests.add(PaymentRequest.fromJson(response['pending_requests'][i]));
      // }
      for (int i = 0; i < response['requests']["data"].length; i++) {
        Completedlist.add(
            PaymentRequest.fromJson(response['requests']['data'][i]));
      }

      context.read<VendorPaymentRequestProvider>().currentPage =
          response['requests']['current_page'];
      context.read<VendorPaymentRequestProvider>().maxPages =
          response['requests']['last_page'];
      context
          .read<VendorPaymentRequestProvider>()
          .addMoreCompletedRequests(Completedlist);
    }
    return true;
  }

  bool isPortrait = true;

  @override
  Widget build(BuildContext context) {
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: Theme.of(context).canvasColor,
          automaticallyImplyLeading: false,
        ),
        body: Consumer<VendorPaymentRequestProvider>(
            builder: (key, provider, child) {
          return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                height: getHeight(context) * .24,
                                // color: kprimaryColor,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [kprimaryColor, Colors.green],
                                        stops: [0.1, 0.8],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight)),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 70,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Image.asset(
                                                'assets/icons/arrow-left.png',
                                                color: Colors.white,
                                                scale: 10,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Wallet',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Text(
                                  'Pending Payments',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              provider.isLoading && provider.pendingRequests.length < 1
                                  // || true
                                  ? PendingRequestItemShimmer()
                                  : IntroScreenSlider(
                                      requests: provider.pendingRequests,
                                    ),
                            ],
                          ),
                        ],
                      )
                    ]),
                  ),
                ];
              },
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                      'Previous Payments',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Expanded(
                      // height: getHeight(context) - 444,
                      child: SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: true,
                        enablePullUp: true,
                        header: BezierHeader(
                          child: Center(
                              child: Column(
                            children: [
                              AppLoader(
                                size: 40.0,
                                strock: 1,
                              ),
                              // Text("Loading")
                            ],
                          )),
                          bezierColor: kYellowColor,
                        ),
                        footer: CustomFooter(
                          builder: smartRefreshFooter,
                        ),
                        onLoading: () async {
                          print("loading");
                          // _refreshController.load
                          bool res = await loadMorePaymentRequest();
                        },
                        onRefresh: () async {
                          bool res = await reset();
                          _refreshController.loadComplete();
                        },
                        child: provider.isLoading &&
                                provider.completedRequests.length < 1
                        // || true
                            ? CompletedPaymentListShimmer()
                            : provider.completedRequests.length < 1
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                      ),
                                      emptyWidget(
                                          description: "No requests available")
                                    ],
                                  )
                                : ListView.builder(
                                    itemCount:
                                        provider.completedRequests.length,
                                    itemBuilder: (context, i) {
                                      return CompletedPaymentRequestItem(
                                          paymentRequest:
                                              provider.completedRequests[i]);
                                    }),
                      )),
                  if (false)
                    Expanded(
                      child: ListView.builder(
                        itemCount: 2,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                                    Row(
                                      children: [
                                        Text(
                                          "Request Id",
                                          style: TextStyle(
                                            color: kYellowColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Spacer(),
                                        Badge(
                                          value: "22",
                                          color: kYellowColor,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          value: 'Completed',
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Amount:",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                        Text('\$50',
                                            style: TextStyle(
                                              color: kprimaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ))
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Request Date:",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.now())}",
                                          style: TextStyle(
                                            color: kYellowColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Approved Date:",
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.now())}",
                                          style: TextStyle(
                                            color: kprimaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 6),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Orders included",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Badge(
                                            value: "2",
                                            color: kprimaryColor,
                                          ),
                                          Spacer(),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'View All',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (false)
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
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        // color: Colors.white,
                      ),
                    ),
                ],
              ));
        }));
  }
}

class CompletedPaymentRequestItem extends StatelessWidget {
  final PaymentRequest paymentRequest;

  CompletedPaymentRequestItem({
    Key? key,
    required this.paymentRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              Row(
                children: [
                  Text(
                    "Request Id",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Badge(
                    value: "${paymentRequest.id}",
                    color: kprimaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Badge(
                    value: '${paymentRequest.paymentStatus}',
                    color: kprimaryColor,
                  )
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Amount:",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text('\$${paymentRequest.amount}',
                      style: TextStyle(
                        color: kprimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ))
                ],
              ),
              Divider(),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Request Date:",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(paymentRequest.createdAt!))}",
                    style: TextStyle(
                      color: kYellowColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Approved Date:",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(paymentRequest.updatedAt!))}",
                    style: TextStyle(
                      color: kprimaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
                child: Row(
                  children: [
                    Text(
                      "Orders included",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Badge(
                      value: "${paymentRequest.paymentRequestOrder!.length}",
                      color: kprimaryColor,
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        bottomModalOrders(context, requestId: paymentRequest.id.toString(), userId: paymentRequest.userId.toString());
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntroScreenSlider extends StatefulWidget {
  final List<PaymentRequest> requests;

  IntroScreenSlider({Key? key, required this.requests}) : super(key: key);

  @override
  State<IntroScreenSlider> createState() => _IntroScreenSliderState();
}

class _IntroScreenSliderState extends State<IntroScreenSlider> {
  @override
  void initState() {
    super.initState();
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.arrow_forward,
      color: kprimaryColor,
      size: 20,
    );
  }

  Widget renderDoneBtn() {
    return SizedBox();
  }

  Widget renderPrevBtn() {
    return Icon(
      Icons.arrow_back,
      color: kprimaryColor,
      size: 20,
    );
  }

  void onDonePress() {
    // Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: IntroSlider(
        // slides: slides,
        // onDonePress: this.onDonePress,
        renderPrevBtn: this.renderPrevBtn(),

        // Next button
        renderNextBtn: this.renderNextBtn(),

        // Done button
        renderDoneBtn: this.renderDoneBtn(),

        // Dot indicator
        colorDot: kprimaryColor,
        showSkipBtn: false,
        showDoneBtn: false,
        sizeDot: 5,
        typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
        key: UniqueKey(),
        // Tabs
        listCustomTabs: [
          ...List.generate(
              widget.requests.length,
              (index) => PendingPaymentRequestItem(
                  paymentRequest: widget.requests[index])),
        ],
        // backgroundColorAllSlides: Colors.transparent,
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }
}

class PendingPaymentRequestItem extends StatelessWidget {
  const PendingPaymentRequestItem({
    Key? key,
    required this.paymentRequest,
  }) : super(key: key);

  final PaymentRequest paymentRequest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 15),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Container(
          // height: 200,
          // width: getWidth(context),
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: itmGreyColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Request Id",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Badge(
                    value: "${paymentRequest.id}",
                    color: kprimaryColor,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total Amount:",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text('\$${paymentRequest.amount}',
                      style: TextStyle(
                        color: kprimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Request Status:",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Badge(
                    value: '${paymentRequest.paymentStatus}',
                    color: kYellowColor,
                    // child: Text('${e.id}',
                    //     style: TextStyle(
                    //       color: kprimaryColor,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 14,
                    //     )),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Request Time:",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Text(
                      '${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(paymentRequest.createdAt!))}',
                      style: TextStyle(
                        color: kprimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ))
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 6),
                child: Row(
                  children: [
                    Text(
                      "Orders included",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Badge(
                      value: "${paymentRequest.paymentRequestOrder!.length}",
                      color: kprimaryColor,
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        bottomModalOrders(context, requestId: paymentRequest.id.toString(), userId: paymentRequest.userId.toString());
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future bottomModalOrders(BuildContext context, {required String userId, required String requestId}) {
  bool isKeyboardAppeared = MediaQuery.of(context).viewInsets.bottom != 0;
  return showModalBottomSheet(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          height: 600,
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(children: [
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28.0, vertical: 8),
                        child: Text(
                          'All Orders',
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(fontSize: 16, color: kprimaryColor, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Expanded(
                        child: WalletPaymentOrdersArea(userId: userId,request_id: requestId,),
                      ),
                    ]),
              ),
            ]),
          ),
        );
      });
}
