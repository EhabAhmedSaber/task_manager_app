import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {

  Future<void> saveUserData(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
  }
}
