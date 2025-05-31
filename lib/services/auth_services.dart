import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String defaultPassword = '12345678';
  static const String validUsername = '123220177'; // Username statis yang valid

  Future<bool> login(String username, String password) async {
    // Validasi username dan password
    if (username != validUsername || password != defaultPassword) {
      throw Exception('Invalid username or password');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isLoggedIn', true);
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('username');
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
