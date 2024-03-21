import 'dart:convert';

import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/conversation.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/material.dart';

class ConversationProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<Conversation> _list = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<Conversation> get list => _list;

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
  set list(List<Conversation> value) {
    _list = value;
    notifyListeners();
  }

  addMore(List<Conversation> value){
    _list.addAll(value);
    notifyListeners();
  }
  updateChat(Conversation conversation){
    int index = _list.indexWhere((element) => element.id == conversation.id);
    if(index>=0) {
      _list[index] = conversation;
      notifyListeners();
    }
  }
  Future<Conversation?> checkChat({context, otherUserId, selfId}) async {
    try {
      User user = (await getUser())!;
      List list = [user.id.toString(), otherUserId.toString()];
      var payload = {"user_ids": jsonEncode(list)};
      showProgressDialog(context, MJConfig.please_wait);
      var response = await MjApiService()
          .postRequest(MJ_Apis.check_chat + "/${selfId}", payload);
      hideProgressDialog(context);
      if (response != null) {
        // Conversation conversation;
        // otherUserProfile = UserProfile.fromJson(response);
        if (response.isNotEmpty) {
          return Conversation.fromJson(response);
        } else {
          return Conversation();
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

}
