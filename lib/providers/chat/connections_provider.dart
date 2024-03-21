import 'package:farmer_app/models/search_profile.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/cupertino.dart';

class FollowingsProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<User> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<User> get list => _list;

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
  set list(List<User> value) {
    _list = value;
    notifyListeners();
  }
  addMore(List<User> value){
    _list.addAll(value);
    notifyListeners();
  }

}

class FollowersProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<User> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<User> get list => _list;

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
  set list(List<User> value) {
    _list = value;
    notifyListeners();
  }
  addMore(List<User> value){
    _list.addAll(value);
    notifyListeners();
  }

}
