import 'package:farmer_app/Ui/app_components/shimmer_ui/voucher_list_shimmer.dart';
import 'package:farmer_app/Ui/vouchers/voucher/voucher_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_voucher.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:farmer_app/providers/voucher/user_voucher_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VoucherAreaSelectable extends StatefulWidget {
  const VoucherAreaSelectable({Key? key}) : super(key: key);

  @override
  State<VoucherAreaSelectable> createState() => _VoucherAreaSelectableState();
}

class _VoucherAreaSelectableState extends State<VoucherAreaSelectable> {
  RefreshController _refreshController = RefreshController();
  User? user = User();

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  getPageData() {
    user = context.read<UserProvider>().currentUser;
    // MjApiService apiService = MjApiService();
    // apiService.getRequest(MJ_Apis.get_user_voucher + '/${user!.id}');

    // if (context.read<UserVoucherProvider>().currentPage < 1)
      getVoucherData();
  }

  reset() async {
    context.read<UserVoucherProvider>().currentPage = 0;
    context.read<UserVoucherProvider>().maxPages = 0;
    context.read<UserVoucherProvider>().list = [];
    context.read<UserVoucherProvider>().isLoading = false;
    bool res = await getVoucherData();
    return res;
  }

  Future<bool> getVoucherData() async {
    context.read<UserVoucherProvider>().isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_user_voucher + "/${user!.id}");
    context.read<UserVoucherProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<Voucher> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(Voucher.fromJson(response['data'][i]));
      }
      context.read<UserVoucherProvider>().currentPage =
          response['current_page'];
      context.read<UserVoucherProvider>().maxPages = response['last_page'];
      context.read<UserVoucherProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreVoucherData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<UserVoucherProvider>().currentPage + 1;
    if (page > context.read<UserVoucherProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService().getRequest(
        MJ_Apis.get_post_list + "?user_id=${user!.id}&page=${page}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<Voucher> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(Voucher.fromJson(response['data'][i]));
      }
      context.read<UserVoucherProvider>().currentPage =
          response['current_page'];
      context.read<UserVoucherProvider>().maxPages = response['last_page'];
      context.read<UserVoucherProvider>().addMore(list);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: getHeight(context) - 370,
        child: Consumer<CartHelper>(
          builder: (key, cartProvider, child) {
            return Consumer<UserVoucherProvider>(builder: (key, provider, child) {
              return SmartRefresher(
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
                  bool res = await loadMoreVoucherData();
                },
                onRefresh: () async {
                  bool res = await reset();
                  _refreshController.loadComplete();
                },
                child: provider.isLoading&& provider.list.length < 1
                    ? VoucherListShimmer()
                    :provider.list.length < 1 ? Column(children: [SizedBox(height: 100,),emptyWidget(description: "No vouchers available")],): ListView.builder(
                        itemCount: provider.list.length,
                        itemBuilder: (context, i) {
                          Voucher voucher = provider.list[i];
                          bool isVoucherSelected =
                              provider.isSelectedVoucher(voucher.id);
                          return InkWell(
                              onTap: () {
                                if (isVoucherSelected) {
                                  provider.unselectVoucher(voucher.id);
                                } else {
                                  if(provider.selectedVoucherTotal < cartProvider.cartTotal){
                                    provider.selectVoucher(voucher.id);

                                  }else{
                                  showToast('You have already selected vouchers enough for your current order');
                                  }
                                }
                              },
                              child: VoucherItem(
                                voucherData: voucher,
                                isSelected: isVoucherSelected,
                                onClose: (){
                                  provider.unselectVoucher(voucher.id);
                                },
                              ));
                        }),
              );
            });
          }
        ));
  }
}
