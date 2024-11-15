import 'package:ez_english/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static final SharedPreferencesUtil instance =
      SharedPreferencesUtil._internal();

  SharedPreferencesUtil._internal();

  static late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void removeValue(String key) {
    printDebug("Removing value for key: $key");
    _prefs.remove(key);
  }

  static void setValue<T>(String key, T value) async {
    if (await _setValue(key, value)) {
      printDebug('Setting value for key: $key');
    } else {
      printDebug('Failed to set value for key: $key');
    }
  }

  static T? getValue<T>(String key) {
    printDebug('Getting value for key: $key');
    T? value = _prefs.get(key) as T?;
    return value;
  }

  static Future<bool> _setValue<T>(String key, T value) {
    if (value is String) {
      return _prefs.setString(key, value);
    } else if (value is int) {
      return _prefs.setInt(key, value);
    } else if (value is bool) {
      return _prefs.setBool(key, value);
    } else if (value is double) {
      return _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      return _prefs.setStringList(key, value);
    } else {
      throw UnsupportedError('Type $T is not supported');
    }
  }
}
