import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyToken = "auth_token";

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    print("Token guardado: $token"); 
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken);
    print("Token recuperado: $token"); 
    return token;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    print("Sesión eliminada"); 
  }
}
