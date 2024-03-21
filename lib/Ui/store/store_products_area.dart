import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/home_produces/basket_cart.dart';
import 'package:farmer_app/Ui/home_produces/single_item_cart.dart';
import 'package:farmer_app/Ui/produces/vendor/vendor_produce_bag_item.dart';
import 'package:farmer_app/Ui/produces/vendor/vendor_product_item.dart';
import 'package:farmer_app/Ui/products/edit_vendor_product.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/models/store.dart';

class StoreProductsArea extends StatefulWidget {
  StoreProductsArea({ required this.storeData, this.isVendor = false, this.isSelf = false});
  final Store storeData;
  final bool isVendor;
  final bool isSelf;

  @override
  State<StoreProductsArea> createState() => _StoreProductsAreaState();
}

class _StoreProductsAreaState extends State<StoreProductsArea> {
  bool isLoading = false;
  List<StoreProduct> list = [];

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
    if (widget.storeData == null) {
      showToast("Cannot get store");
      return;
    }
    var response = await MjApiService()
        .getRequest("${MJ_Apis.get_store_products}/${widget.storeData.id}");
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      list = [];

      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduct.fromJson(response[i]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('userId: ${widget.storeData.userId}');
    return Container(
      height: getHeight(context) - 285,
      child: isLoading&& list.length < 1
          ? Center(child: AppLoader())
          : list.length == 0
              ? Center(child: emptyWidget(description: "No single items available for this store!"),)
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, index) => VendorProductItem(
                    storeProduct: list[index],
                    actionTitle: widget.isSelf && widget.isVendor ? 'Edit': '',
                    actionCallback: () {},
                    id: "produce_"+list[index].id!.toString(),
                    onTap: widget.isVendor ? null :  () {
                      if(list[index].store == null){
                        list[index].store = widget.storeData;
                      }

                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (context, _, __) => SingleItem(
                            id: "produce_"+list[index].id!.toString(), storeProduct: list[index],
                          ),
                        ),
                      );

                    },
                  ),
                ),
    );
  }
}
