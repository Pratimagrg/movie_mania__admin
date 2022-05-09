import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String access = "accessToken";
  static String firebaseRegistrationToken = "firebaseRegistrationToken";

  Future<bool> setAccessToken(String setAccess) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(access, setAccess);
  }

  Future<bool> setRegistrationToken(String registrationToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firebaseRegistrationToken, registrationToken);
  }

  clearAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<String?> getAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(access);
  }

  Future<String?> getRegistrationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firebaseRegistrationToken);
  }
}
