import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:flutter/cupertino.dart';

class HomeProduceBagProvider extends ChangeNotifier {
  List<StoreProduceBag> _list = [];
  List<StoreProduceBag> get list => _list;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(value){
    _isLoading = value;
    notifyListeners();
  }
  set(data) {
    if (data != null) {
      _list.clear();
      _list.addAll(data);
      notifyListeners();
    }
  }
}
