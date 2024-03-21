import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:flutter/cupertino.dart';

class VendorProduceBagProvider extends ChangeNotifier {
  List<StoreProduceBag> _list = [];
  List<StoreProduceBag> get list => _list;

  set(data) {
    if (data != null) {
      _list.clear();
      _list.addAll(data);
      notifyListeners();
    }
  }
}
