import 'package:farmer_app/Ui/app_components/shimmer_ui/other_vendor_store_list_shimmer.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_store_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/models/store.dart' as store;

import 'other_vendor_store_item.dart';

class UserProfileVendorStores extends StatefulWidget {
  const UserProfileVendorStores({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<UserProfileVendorStores> createState() => _UserProfileVendorStoresState();
}

class _UserProfileVendorStoresState extends State<UserProfileVendorStores> {
  List<store.Store> list = [];
  bool isLoading = false;

  @override
  void initState() {
    getPageData();

    super.initState();
  }

  getPageData() async {
    setState(() {
      isLoading = true;
    });

    var response =
    await MjApiService().getRequest(MJ_Apis.vendor_stores + "/" + widget.userId);
    if (response != null) {
      list.clear();
      for (int i = 0; i < response.length; i++) {
        list.add(store.Store.fromJson(response[i]));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: isLoading ? OtherVendorStoreListShimmer() : list.length > 0 ? ListView(
          children: List.generate(
            list.length,
                (index) => OtherVendorStoreItem(
              store: list[index],
              colorVary: index,
            ),
          )) : Center(child: Text('No Stores to show')),
    );
  }
  @override
  void setState(VoidCallback fn) {
    if(mounted){

    super.setState(fn);
    }
  }
}
