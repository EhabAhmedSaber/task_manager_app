import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'JWT_TOKEN';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
