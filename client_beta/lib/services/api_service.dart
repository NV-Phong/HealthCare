import 'dart:convert';
import 'package:client_beta/services/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final SecureStorageService _secureStorageService = SecureStorageService();
  final String baseUrl;

  ApiService(this.baseUrl);

  // Hàm đăng nhập người dùng
  Future<String?> loginUser(String username, String password) async {
    print(this.baseUrl + '/auth/login');
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // Giả sử JWT token được trả về trong body của response
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData[
          'access_token']; // Trả về token nếu đăng nhập thành công
    } else {
      // Trả về null nếu đăng nhập thất bại
      return null;
    }
  }

  // Future<void> logout() async {
  //   _secureStorageService.removeToken();
  //   Navigator.of(context).pushReplacementNamed('/');
  // }
}