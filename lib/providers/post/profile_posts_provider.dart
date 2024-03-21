import 'package:farmer_app/models/post_data.dart';
import 'package:flutter/cupertino.dart';

class ProfilePostProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<PostData> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<PostData> get list => _list;

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
  set list(List<PostData> value) {
    _list = value;
    notifyListeners();
  }
  addMore(List<PostData> value){
    _list.addAll(value);
    notifyListeners();
  }

}