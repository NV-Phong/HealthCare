import 'package:flutter/material.dart';
// import 'package:client_beta/services/login_API.dart'; // Đảm bảo bạn đã nhập đúng đường dẫn đến ApiService
// import 'package:client_beta/models/Login-DTO.dart'; // Nhập mô hình User nếu bạn sử dụng
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client_beta/services/flutter_secure_storage.dart';
import '../services/api_service.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final SecureStorageService _secureStorageService = SecureStorageService();
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService('${dotenv.env['LOCALHOST']}');
  final storage = FlutterSecureStorage();
  Future<void> login() async {
    // Lấy dữ liệu từ TextField
    final username = _usernameController.text;
    // String email = _emailController.text;
    final password = _passwordController.text;

    // Gọi API để đăng nhập
    String? token = await _apiService.loginUser(username, password);
    if (token != null) {
      // Xử lý khi đăng nhập thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thành công! Token: $token')),
      );

      // Có thể chuyển hướng sang màn hình khác hoặc lưu token
      await _secureStorageService.saveToken(token);
      Navigator.pushNamed(context, '/testdata');
    } else {
      // Xử lý khi đăng nhập thất bại
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng nhập thất bại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // Thêm padding cho layout đẹp hơn
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to the Login Page!'),
              SizedBox(height: 20),

              // Username Input
              Container(
                width: 300, // Đặt chiều rộng cho TextField
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // Góc bo tròn
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              Container(
                width: 300, // Đặt chiều rộng cho TextField
                child: TextField(
                  controller: _passwordController,
                  obscureText: true, // Ẩn mật khẩu
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // Góc bo tròn
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: login, // Gọi hàm đăng nhập khi nhấn nút
                child: Text('Login'), // Nút đăng nhập
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/testdata');
                },
                child: Text('Test Data'), // Nút kiểm tra dữ liệu
              ),
              SizedBox(height: 10),

              // Nút để đăng ký
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
