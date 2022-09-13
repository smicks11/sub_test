import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences with ChangeNotifier {
  static SharedPreferences? _preferences;
  static const _keyFName = 'fName';
  static const _keyLName = 'lName';
  static const _keyEmail = 'email';
  static const _keyPassword = 'pwd';
  static const _keyPoint = 'point';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setProfileData(
      String name, String email, String password, int point) async {
    await _preferences?.setString(_keyFName, name);
    await _preferences?.setString(_keyEmail, email);
    await _preferences?.setString(_keyPassword, password);
    await _preferences?.setInt(_keyPoint, point);
  }

  //GETTERS

  static String? getFName() {
    return _preferences?.getString(_keyFName);
  }

  static String? getLName() {
    return _preferences?.getString(_keyLName);
  }

  static String? getEmail() {
    return _preferences?.getString(_keyEmail);
  }

  static String? getPwd() {
    return _preferences?.getString(_keyPassword);
  }
}
