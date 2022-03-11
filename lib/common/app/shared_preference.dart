import 'package:shared_preferences/shared_preferences.dart';

const String isLogIn = 'isLogIn';
const String isSocialLogin = 'isSocialLogin';

checkPrefKey(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(key);
}

getPrefStringValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setPrefStringValue(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

getPrefBoolValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key);
}

setPrefBoolValue(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(key, value);
}

getPrefIntValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(key);
}

setPrefIntValue(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

removePrefValue(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
