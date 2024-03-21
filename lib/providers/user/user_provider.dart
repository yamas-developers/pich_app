import 'dart:developer';

import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../api/mj_apis.dart';
import '../../helpers/constraints.dart';
import '../../helpers/session_helper.dart';

class UserProvider extends ChangeNotifier {
  User? currentUser;

  setUser(User user) {
    currentUser = user;
    notifyListeners();
  }

  Future<bool> update_user_status(String status) async {
    if (currentUser?.id == null) {
      showToast('Unable to update status');
      return false;
    }
    dynamic payLoad = {"status": status};
    dynamic response = await MjApiService().postRequest(
        "${MJ_Apis.update_user_status}/${currentUser?.id}", payLoad);
    log('response status: $response');
    if (response != null) {
      showToast('User account is unable to use now');
      return true;
    }
    return false;
  }

  Future<bool> blockUser(String? blockUserId) async {
    String? selfId = (await getUser())?.id;
    if (selfId == null || blockUserId == null) {
      return false;
    }
    var response = await MjApiService()
        .getRequest(MJ_Apis.block_user + "/${selfId}/${blockUserId}");
    if (response != null) {
      log('MK: post data: ${response}');
      return true;
    }
    return false;
  }
}
