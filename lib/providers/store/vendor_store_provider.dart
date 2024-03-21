import 'dart:convert';

import 'package:farmer_app/Ui/store/store.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/store.dart' as store;
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/vendor_dashboard_store_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorStoreProvider extends ChangeNotifier {
  List<store.Store> _list = [];
  store.Store? currentStore;

  VendorDashboardStoreData _currentStoreData = VendorDashboardStoreData();

  List<store.Store> get list => _list;
  VendorDashboardStoreData get currentStoreData => _currentStoreData;
  store.Store get getStore => currentStore!;
  bool loading = false;

  VendorStoreProvider() {
    // getVendorStores();
  }

  set(list) {
    _list.clear();
    _list.addAll(list);
    notifyListeners();
  }

  setCurrentStore(storeId) async {
    var _store = list.where((element) => element.id == storeId);
    if (_store.isNotEmpty) {
      currentStore = _store.first;
      notifyListeners();
      try {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('store', jsonEncode(_store.first.toJson()));
      } catch (e) {
        print(e.toString());
      }
    }

  }

  getCurrentStore() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String storeString = sharedPreferences.getString('store')!;
      print("Store=======>");
      print("My Store => ${storeString}");
      if (storeString.isNotEmpty) {
        store.Store _store = store.Store.fromJson(jsonDecode(storeString));
        if (_store.id != null) {
          var __store = list.where((element) => element.id == _store.id);
          if (__store.isNotEmpty) {
            currentStore = __store.first;
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  remove(index) {
    _list.removeAt(index);
    notifyListeners();
  }

  getVendorStores() async {
    User user = (await getUser())!;
    loading = true;
    notifyListeners();
    var response =
        await MjApiService().getRequest(MJ_Apis.vendor_stores + "/" + user.id!);
    loading = false;
    if (response != null) {
      list.clear();
      for (int i = 0; i < response.length; i++) {
        list.add(store.Store.fromJson(response[i]));
      }
    }
    getCurrentStore();
    notifyListeners();
  }
  getVendorStoreData() async {
    User user = (await getUser())!;
    if(currentStore == null) return;
    loading = true;
    notifyListeners();
    var response =
    await MjApiService().getRequest(MJ_Apis.today_store_data + "/" + currentStore!.id.toString());
    loading = false;
    if (response != null) {
    print('storeData: ${response}');

    _currentStoreData = VendorDashboardStoreData.fromJson(response);

    }
    notifyListeners();
  }
}
