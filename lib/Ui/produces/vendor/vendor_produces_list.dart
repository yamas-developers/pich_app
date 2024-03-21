import 'package:farmer_app/Ui/home_produces/home_produce_bag_item.dart';
import 'package:farmer_app/Ui/produces/vendor/add_vendor_produce.dart';
import 'package:farmer_app/Ui/produces/vendor/vendor_produce_bag_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/providers/produce_bag/vendor_produce_bag_provider.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../../../helpers/color_constants.dart';
import 'edit_vendor_produces.dart';

class VendorProduceBagsScreen extends StatefulWidget {
  static const String routeName = "/vendor_product_bags";

  const VendorProduceBagsScreen({Key? key}) : super(key: key);

  @override
  State<VendorProduceBagsScreen> createState() =>
      _VendorProduceBagsScreenState();
}

class _VendorProduceBagsScreenState extends State<VendorProduceBagsScreen> {
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
    if(store == null){
      showToast("Cannot get store");
      return;
    }
    var response = await MjApiService()
        .getRequest("${MJ_Apis.get_store_product_bag}/${store.id}");
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      List<StoreProduceBag> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduceBag.fromJson(response[i]));
      }
      context.read<VendorProduceBagProvider>().set(list);
    }
  }
  @override
  void didChangeDependencies() {
    getPageData();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
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
                                      Flexible(
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
                                        Navigator.of(context).pushNamed(
                                            AddVendorProduce.routeName);
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
            child: Consumer<VendorProduceBagProvider>(
                builder: (key, provider, child) {
              return isLoading && provider.list.length < 1
                  ? AppLoader()
                  : provider.list.isEmpty ? emptyWidget(description: "No food boxes available") : Container(
                      height: getHeight(context) - 285,
                      child: ListView.builder(
                        itemCount: provider.list.length,
                        itemBuilder: (ctx, i) => VendorProduceBagItem(
                            storeProduce: provider.list[i], actionTitle: 'Edit',actionCallback: (){
                          Navigator.pushNamed(context, EditVendorProduce.routeName, arguments: provider.list[i]);
                        },),
                      ),
                    );
            }),
          ),
        ),
      ),
    );
  }
}
