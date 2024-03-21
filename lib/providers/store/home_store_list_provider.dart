import 'dart:convert';

import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/store.dart' as store;
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStoreListProvider extends ChangeNotifier {
  List<store.Store> _list = [];
  List<store.Store> get list => _list;
  bool loading = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(value){
    _isLoading = value;
    notifyListeners();
  }

  set(list) {
    _list.clear();
    _list.addAll(list);
    notifyListeners();
  }
getCurrentStore(int? id){
  if (id == null) return;
  Store store = _list.firstWhere((element) => element.id == id);
  print('store: ${store}');
  return store;
  // if (index >= 0) {
  //   return true;
  // }
  //
  // return false;
}

}
