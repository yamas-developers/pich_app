// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/produces/vendor/add_vendor_produce.dart';
import 'package:farmer_app/Ui/produces/vendor/edit_vendor_produces.dart';
import 'package:farmer_app/Ui/products/edit_vendor_product.dart';
import 'package:farmer_app/Ui/products/products.form.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:farmer_app/providers/product/store_product.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../../helpers/color_constants.dart';

class Products extends StatefulWidget {
  static const String routeName = "/product";

  const Products({Key? key}) : super(key: key);

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool isLoading = false;
  late Store store = context.read<VendorStoreProvider>().currentStore!;

  getPageData() async {
    if (store == null) {
      showToast("cannot find store");
      return;
    }
    setState(() {
      isLoading = true;
    });
    var response = await MjApiService()
        .getRequest("${MJ_Apis.get_store_products}/${store.id}");
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      List<StoreProduct> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduct.fromJson(response[i]));
      }
      context.read<StoreProductProvider>().set(list);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getPageData();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  var size, height;

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kYellowColor,
        toolbarHeight: 0,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroll) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    // AppLoader(),
                    Container(
                      height: 147,
                      decoration: BoxDecoration(
                        color: kYellowColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(19),
                          bottomRight: Radius.circular(19),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Flex(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Image.asset(
                                            "assets/images/arrow-left.png",
                                            height: 25,
                                          )),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (store != null)
                                              Text(
                                                "${store.storeName}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            if (store != null)
                                              if (store.address != null)
                                                Text(
                                                  "${store.address}",
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(ProductForm.routeName);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 83,
                                        decoration: BoxDecoration(
                                            color: kprimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(11)),
                                        child: Center(
                                          child: Text(
                                            "Add",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //           height: 57,
                    //           decoration: BoxDecoration(
                    //               color: kprimaryColor,
                    //               borderRadius: BorderRadius.circular(19)),
                    //           child: Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   "Search items",
                    //                   style: TextStyle(color: Colors.white),
                    //                 ),
                    //                 Image.asset(
                    //                   "assets/icons/search.png",
                    //                   height: 21,
                    //                 )
                    //               ],
                    //             ),
                    //           )),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ]),
            ),
          ];
        },
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Consumer<StoreProductProvider>(
                builder: (key, provider, widget) {
              return isLoading&& provider.list.length < 1
                  ? Center(child: AppLoader())
                  : provider.list.isEmpty ? emptyWidget(description: "No single items available") : Container(
                      height: height - 285,
                      child: ListView.builder(
                        itemCount: provider.list.length,
                        itemBuilder: (ctx, i) => ProducesListContainer(
                          context: context,
                          storeProduct: provider.list[i]
                        ),
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}

Container ProducesListContainer({
  required BuildContext context,
  required StoreProduct storeProduct,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
    padding: EdgeInsets.all(2),
    height: 101,
    decoration: BoxDecoration(
      color: kGreyColor,
      borderRadius: BorderRadius.circular(19),
    ),
    child: Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(18.0),
            child: CacheImage(
              url: "${MJ_Apis.APP_BASE_URL+storeProduct.products!.image!}",
              width: 57,
              height: 57,
              fit: BoxFit.contain,
            )),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${storeProduct.products!.productName}",
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).primaryColor),
              ),
              Text(
                'Size ${storeProduct.size}',
                style: TextStyle(fontSize: 10),
              ),
              SizedBox(height: 3,),
              Badge(
                value: '${storeProduct.status}',
                color: kprimaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                // SizedBox(width: 5),
                child: Text(
                  '\$${storeProduct.price}',
                  style: TextStyle(fontSize: 15, color: kprimaryColor),
                ),
              ),
            ],
          ),
        ),
        TouchableOpacity(
          onTap: () {
            Navigator.pushNamed(context, EditVendorProductScreen.routeName,arguments: storeProduct);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              height: 40,
              width: 83,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11), color: kYellowColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
