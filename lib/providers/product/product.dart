import 'package:farmer_app/models/product.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier{
  List<Product> _list = [];
  List<Product> get list => _list;

  set(data){
    if(data != null) {
      _list.clear();
      _list.addAll(data);
      notifyListeners();
    }
  }

}