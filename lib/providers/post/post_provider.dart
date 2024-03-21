import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer';

class PostProvider extends ChangeNotifier {
  int _currentPage = 0;
  int _maxPages = 0;
  List<PostData> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;

  int get maxPages => _maxPages;

  bool get isLoading => _isLoading;

  List<PostData> get list => _list;

  set isLoading(bool value) {
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

  addMore(List<PostData> value) {
    _list.addAll(value);
    notifyListeners();
  }

  likePost(int? postId, String type) async {
    if (postId == null) return false;
    MjApiService apiService = MjApiService();
    User? user = await getUser();
    Map payload = {"post_id": postId.toString(), "type": type};
    final response = await apiService.simplePostRequest(
        MJ_Apis.add_like + '/${user!.id}', payload);
    if (response != null) {
      return true;
    }
    return false;
  }

  reportPost(int? postId, String? reason) async {
    if (postId == null) {
      return false;
    }
    MjApiService apiService = MjApiService();
    User? user = await getUser();
    Map payload = {
      "post_id": postId.toString(),
      "reason": reason ?? '',
      "user_id": user?.id ?? ''
    };
    final response =
        await apiService.simplePostRequest(MJ_Apis.report_post, payload);
    if (response != null) {
      _list.removeWhere((element) => element.id == postId);
      notifyListeners();
      return true;
    }
    return false;
  }

  removePostsFromUser(String? userId) {
    if (userId == null) {
      return;
    }
    _list.removeWhere((element) => element.postUser?.id == userId);
    notifyListeners();
  }

  Future<PostData?> getPostData(String selfId, String postId) async {
    var response = await MjApiService().getRequest(
        MJ_Apis.post_detail + "?user_id=${selfId}&post_id=${postId}");
    PostData? postData;
    if (response != null) {
      log('MK: post data: ${response}');
      postData = PostData.fromJson(response);
    }
    return postData;
  }
}
