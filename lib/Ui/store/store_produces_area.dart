import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/home_produces/basket_cart.dart';
import 'package:farmer_app/Ui/produces/vendor/edit_vendor_produces.dart';
import 'package:farmer_app/Ui/produces/vendor/vendor_produce_bag_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/models/store.dart' ;


class StoreProducesArea extends StatefulWidget {
   StoreProducesArea({ required this.storeData, this.isVendor = false, this.isSelf = false});
  final Store storeData;
  final bool isVendor;
  final bool isSelf;

  @override
  State<StoreProducesArea> createState() => _StoreProducesAreaState();
}

class _StoreProducesAreaState extends State<StoreProducesArea> {
  bool isLoading = false;
  List<StoreProduceBag> list = [];


  @override
  void didChangeDependencies() {
    getPageData();
super.didChangeDependencies();
  }

  getPageData() async {
    if (widget.storeData == null) {
      showToast("cannot find store");
      return;
    }
    setState(() {
      isLoading = true;
    });
    if(widget.storeData == null){
      showToast("Cannot get store");
      return;
    }
    var response = await MjApiService()
        .getRequest("${MJ_Apis.get_store_product_bag}/${widget.storeData.id}");
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      list = [];

      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduceBag.fromJson(response[i]));
        // print('store in produces area: ${response[i]["store_id"]}');

      }
    }
  }
  @override
  Widget build(BuildContext context) {
    print('status: ${widget.isSelf} && ${widget.isVendor}');
    return Container(
      height: getHeight(context) - 285,
      child: isLoading&& list.length < 1
          ? Center(child: AppLoader()) : list.length == 0 ? Center(child: emptyWidget(description: "No food boxes available for this store!"),): ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, index) => VendorProduceBagItem(
          storeProduce: list[index],
          actionTitle: widget.isSelf && widget.isVendor ? 'Edit': '',
          actionCallback: (){
            Navigator.pushNamed(context, EditVendorProduce.routeName);
          },
          id: "produce_bag_${list[index].id!}",
          onTap: widget.isVendor ? null : (){
            List<Product> productList = [];

            if (list != null) {

              if(list[index].store == null){
                list[index].store = widget.storeData;
              }
            }
            Navigator.push(
              context,
              PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, _, __) => BasketCartActivity(
                    id: "produce_bag_${list[index].id!}",
                    bag: list[index],
                  )),
            );
          },
        ),
      ),
    );
  }
}
