import 'dart:convert';
import 'package:client_beta/models/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:3000'; // Đặt URL của server API

  // Phương thức đăng ký
  Future<bool> registerUser(User user) async {
    final String endpoint = '/auth/register'; // Endpoint của API đăng ký

    final Uri url = Uri.parse('$baseUrl$endpoint');

    try {
      // Gửi yêu cầu POST tới server
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(user.toJson()), // Chuyển dữ liệu thành JSON
      );

      // Kiểm tra phản hồi từ server
      if (response.statusCode == 201) {
        print('Đăng ký thành công');
        return true; // Thành công
      } else {
        print('Lỗi: ${response.body}');
        return false; // Lỗi
      }
    } catch (error) {
      print('Lỗi khi kết nối tới server: $error');
      return false; // Lỗi kết nối
    }
  }
}
