import 'package:farmer_app/models/post_comment.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:flutter/cupertino.dart';

class PostCommentProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<PostComment> _list = [];
  bool _isLoading = false;
  String _postId = "0";

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  String get postId => _postId;
  List<PostComment> get list => _list;

  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
  set postId(String id){
    _postId = id;
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
  set list(List<PostComment> value) {
    _list = value;
    notifyListeners();
  }

  addOne(PostComment comment){
    if(comment != null){
    _list.insert(0, comment);
    notifyListeners();
    }
  }
  addMore(List<PostComment> value){
    _list.addAll(value);
    notifyListeners();
  }

}
