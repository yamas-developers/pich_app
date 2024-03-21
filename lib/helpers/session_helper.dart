import 'dart:convert';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

setUser(User currentUser) async {
  // print("here");
  final prefs = await SharedPreferences.getInstance();
  // print("here3");
  await prefs.setString(
      MJConfig.mj_session_user, jsonEncode(currentUser.toJson()));
  // print("here2");
}

Future<bool> isUser() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    dynamic data = jsonDecode(await prefs.getString(MJConfig.mj_session_user)!);
    if (data == null || data.isEmpty) {
      return false;
    }
    User user = User.fromJson(data);
    if (user == null) {
      return false;
    }

    if (user.rolesId.toString() == USER.toString()) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> isVendor() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    dynamic data = jsonDecode(await prefs.getString(MJConfig.mj_session_user)!);
    if (data == null || data.isEmpty) {
      return false;
    }
    User user = User.fromJson(data);
    if (user == null) {
      return false;
    }

    if (user.rolesId == VENDOR) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    return false;
  }
}

//
Future<User?> getUser() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    User user = new User();
    dynamic data = jsonDecode(await prefs.getString(MJConfig.mj_session_user)!);
    // print(data);
    if (data == null) {
      return User();
    }
    if (data.isEmpty) {
      return User();
    }
    print("success User In SESSION HELPER");
    user = User.fromJson(data);
    return user;
  } catch (e) {
    return User();
  }
}

//
Future<bool> isLogin() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String userData = await prefs.getString(MJConfig.mj_session_user)!;
    if (userData == null) {
      return false;
    }
    if (userData == '' || userData.isEmpty) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    return false;
  }
}
logout() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    bool res = await prefs.remove(MJConfig.mj_session_user);
    if(res){
      return true;
    }else{
      return false;
    }
  } catch (e) {
    return false;
  }
}
