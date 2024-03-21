import 'package:farmer_app/models/user_notification.dart';
import 'package:flutter/cupertino.dart';

class UserNotificationProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<UserNotification> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<UserNotification> get list => _list;

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
  set list(List<UserNotification> value) {
    _list = value;
    notifyListeners();
  }

  addOne(UserNotification comment){
    if(comment != null){
      _list.insert(0, comment);
      notifyListeners();
    }
  }
  addMore(List<UserNotification> value){
    _list.addAll(value);
    notifyListeners();
  }

}
