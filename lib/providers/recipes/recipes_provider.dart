import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/recipes_data.dart';
import 'package:flutter/cupertino.dart';

class RecipesProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<RecipesData> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<RecipesData> get list => _list;

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
  set list(List<RecipesData> value) {
    _list = value;
    notifyListeners();
  }
  addMore(List<RecipesData> value){
    _list.addAll(value);
    notifyListeners();
  }

}
