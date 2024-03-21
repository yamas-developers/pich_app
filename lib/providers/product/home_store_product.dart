import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:flutter/cupertino.dart';

class HomeStoreProductProvider extends ChangeNotifier{
  List<StoreProduct> _list = [];
  List<StoreProduct> get list => _list;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(value){
    _isLoading = value;
    notifyListeners();
  }

  set(data){
    if(data != null) {
      _list.clear();
      _list.addAll(data);
      notifyListeners();
    }
  }

}