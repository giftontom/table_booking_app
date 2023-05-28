import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static final String _clientId = "client_id";
  static final String _clientKey = "client_key";

  static Future<bool> isLoggedIn() async {
    String key = await getClientKey();
    return !key.trim().isEmpty;
  }

  static Future<String> getClientId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_clientId) ?? '';
  }

  static Future<bool> setClientId(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_clientId, value);
  }

  static Future<String> getClientKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_clientKey) ?? '';
  }

  static Future<bool> setClientKey(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_clientKey, value);
  }

  static Future<bool> removeClientInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove(_clientId);
    prefs.remove(_clientKey);
    return true;
  }
}
