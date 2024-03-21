import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MyProfileProvider extends ChangeNotifier{
  User currentUser = User();
  bool _isLoading = false;
  bool _isError = false;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  set isLoading(value){
    _isLoading = value;
    notifyListeners();
  }
  set isError(value){
    _isError = value;
    notifyListeners();
  }
  setMyProfile(User user) {
    currentUser = user;
    notifyListeners();
  }
}
