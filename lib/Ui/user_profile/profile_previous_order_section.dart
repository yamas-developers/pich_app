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
import 'package:farmer_app/providers/order/user_order_provider.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfilePreviousOrderSection extends StatefulWidget {
  const ProfilePreviousOrderSection(
      {Key? key, required this.userId, this.isVendor = false})
      : super(key: key);
  final String userId;
  final bool isVendor;

  @override
  State<ProfilePreviousOrderSection> createState() =>
      _ProfilePreviousOrderSectionState();
}

class _ProfilePreviousOrderSectionState
    extends State<ProfilePreviousOrderSection> {
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) => getPageData());
    super.initState();
  }

  getPageData() async {
    // if (context.read<ProfilesProvider>().currentPage < 1)
    // Map payload = {"type":"by_user","order_user":widget.userId,"order_status":"Pending"};
    // var response =
    // await MjApiService().postRequest(MJ_Apis.get_all_orders + "/${widget.userId}", payload);
    // print('ordersResponse: ${jsonEncode(response["data"][0]["order_produce"][0])}');
    getOrdersData();
  }

  reset() async {
    context.read<UserPreviousOrderProvider>().currentPage = 0;
    context.read<UserPreviousOrderProvider>().maxPages = 0;
    context.read<UserPreviousOrderProvider>().list = [];
    context.read<UserPreviousOrderProvider>().isLoading = false;
    bool res = await getOrdersData();
    return res;
  }

  Future<bool> getOrdersData() async {
    Map payload = {};

    if (widget.isVendor) {
      int storeId = context.read<VendorStoreProvider>().currentStore!.id!;
      payload = {
        "type": "by_store",
        "order_store": storeId.toString(),
        "order_status": ""
      };
    } else {
      payload = {
        "type": "by_user",
        "order_user": widget.userId,
        "order_status": ""
      };
    }
    context.read<UserPreviousOrderProvider>().isLoading = true;
    var response = await MjApiService()
        .postRequest(MJ_Apis.get_all_orders + "/${widget.userId}", payload);
    print('orderResponse: ${response}');
    context.read<UserPreviousOrderProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<OrderData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(OrderData.fromJson(response['data'][i]));
      }
      context.read<UserPreviousOrderProvider>().currentPage = response['current_page'];
      context.read<UserPreviousOrderProvider>().maxPages = response['last_page'];
      context.read<UserPreviousOrderProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    Map payload = {};
    int page = context.read<UserPreviousOrderProvider>().currentPage + 1;
    if (page > context.read<UserPreviousOrderProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    print('currentPage: ${page} ${context.read<UserPreviousOrderProvider>().maxPages}');
    if (widget.isVendor) {
      int storeId = context.read<VendorStoreProvider>().currentStore!.id!;
      payload = {
        "type": "by_store",
        "order_store": storeId.toString(),
        "order_status": "",
        "page": page.toString()

      };
    } else {
      payload = {
        "type": "by_user",
        "order_user": widget.userId,
        "order_status": "",
        "page": page.toString()
      };
    }
    var response = await MjApiService().postRequest(
        MJ_Apis.get_all_orders + "/${widget.userId}&page=${page}", payload);
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<OrderData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(OrderData.fromJson(response['data'][i]));
      }
      debugPrint("currentPage api ${context.read<UserPreviousOrderProvider>().currentPage}");
      context.read<UserPreviousOrderProvider>().currentPage = response['current_page'];
      context.read<UserPreviousOrderProvider>().maxPages = response['last_page'];
      context.read<UserPreviousOrderProvider>().addMore(list);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPreviousOrderProvider>(builder: (key, provider, child) {
      return Container(
        height: getHeight(context) - 140,
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
            height: 120,
          ),
          onLoading: () async {
            print("loading");
            // _refreshController.load
            bool res = await loadMoreData();
          },
          onRefresh: () async {
            bool res = await reset();
            _refreshController.loadComplete();
          },
          child: ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              provider.isLoading
                  && provider.list.length < 1
                  ? SizedBox(
                      height: getHeight(context), child: UserOrderListShimmer())
                  : provider.list.length < 1
                      ? emptyWidget(description: "No orders found")
                      : Column(
                          children: List.generate(
                            provider.list.length,
                            (index) {
                              print('length: ${provider.list.length}');
                              return Column(
                                children: [
                                  OrderUserItem(
                                    orderData: provider.list[index],
                                    // commentItem: PostComment(
                                    //     comment:
                                    //     provider.list[0].comment,
                                    //     user: User(
                                    //         profileImage: user!.profileImage,
                                    //         firstname: user!.id)),
                                    // commentItem: provider.list[index],
                                    // selfId: widget.userId,
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        ),
              // SizedBox(height: 140),
            ],
          ),
        ),
      );
    });
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
