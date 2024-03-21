import 'package:shared_preferences/shared_preferences.dart';
class PrefsHelper{
  static String HOME_INTRO_KEY = 'home_intro';
  static String VENDOR_HOME_INTRO_KEY = 'vendor_home_intro';
  static String CHAT_INTRO_KEY = 'chat_intro';
  static String POST_INTRO_KEY = 'post_intro';

  late SharedPreferences preferences;

  PrefsHelper(){
  }
  Future<SharedPreferences> getInstance() async {
    preferences = await SharedPreferences.getInstance();
    return preferences;
  }
  String? getString(key) {
    return preferences.getString(key) ?? null;
  }
  Future<bool> setString(key, value) async {
    return preferences.setString(key, value);
  }

}