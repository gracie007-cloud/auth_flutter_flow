import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static final String endPoint = '/api/v1/auth_user';

  static final String authTokenKey = 'auth_token';
  static final String userIdKey = 'user_id';
  static final String nameKey = 'name';
  static final String roleKey = 'role';

  static String? getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }

  static void insertDetails(SharedPreferences prefs, dynamic response) {
    prefs.setString(authTokenKey, response['auth_token'] as String);
    final user = response['user'];
    prefs.setInt(userIdKey, user['id'] as int);
    prefs.setString(nameKey, user['name'] as String);
  }
}
