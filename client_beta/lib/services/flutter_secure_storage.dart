import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _secureStorage = FlutterSecureStorage();
  // Lưu token vào Secure Storage
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'jwt_token', value: token);
  }

  // Lấy token từ Secure Storage
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'jwt_token');
  }

  // Xóa token khỏi Secure Storage
  Future<void> removeToken() async {
    await _secureStorage.delete(key: 'jwt_token');
  }
}