import 'package:farmer_app/models/order_data.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:flutter/cupertino.dart';

class UserCurrentOrderProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<OrderData> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<OrderData> get list => _list;

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  set maxPages(int value) {
    _maxPages = value;
    notifyListeners();
  }
  set list(List<OrderData> value) {
    _list = value;
    notifyListeners();
  }
  addMore(List<OrderData> value){
    _list.addAll(value);
    notifyListeners();
  }
  changeOrderStatus(int orderId, String status){
    _list.forEach((element) {
      if(element.id == orderId){
        int index = _list.indexOf(element);
        element.orderStatus = status;
        _list[index] = element;
        notifyListeners();
        return;
      }
    });
  }

}

class UserPreviousOrderProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<OrderData> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<OrderData> get list => _list;

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  set maxPages(int value) {
    _maxPages = value;
    notifyListeners();
  }
  set list(List<OrderData> value) {
    _list = value;
    notifyListeners();
  }
  addMore(List<OrderData> value){
    _list.addAll(value);
    notifyListeners();
  }
  changeOrderStatus(int orderId, String status){
    _list.forEach((element) {
      if(element.id == orderId){
        int index = _list.indexOf(element);
        element.orderStatus = status;
        _list[index] = element;
        notifyListeners();
        return;
      }
    });
  }

}
