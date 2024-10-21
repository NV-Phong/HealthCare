// ignore_for_file: prefer_const_constructors

import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:client_beta/services/login_API.dart'; // Đảm bảo bạn đã nhập đúng đường dẫn đến ApiService
import 'package:client_beta/models/Login-DTO.dart'; // Nhập mô hình User nếu bạn sử dụng
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  final storage = FlutterSecureStorage();
  Future<void> login() async {
    // Lấy dữ liệu từ TextField
    String username = _usernameController.text;
    // String email = _emailController.text;
    String password = _passwordController.text;

    //Tạo đối tượng User (nếu cần)
    User user = User(
        username: username,
        // email: email,
        password: password); // Đảm bảo bạn đã định nghĩa lớp User

    //Gọi phương thức đăng nhập
    bool success =
        await apiService.loginUser(user); // Gọi phương thức từ ApiService

    if (success) {
      // String Token = await apiService.loginUser(user);
      Future<void> saveToken(String token) async {
        await storage.write(key: 'access_token', value: token);
      }

      // Đăng nhập thành công, điều hướng đến trang chính hoặc hiển thị thông báo
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đăng nhập thành công')));
      // Bạn có thể điều hướng đến trang chính ở đây
      Navigator.pushNamed(context,
          '/testdata'); // Điều hướng đến trang chính sau khi đăng nhập thành công
    } else {
      // Đăng nhập không thành công, hiển thị thông báo lỗi
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Đăng nhập thất bại')));
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
              //Email Input
              // Container(
              //   width: 300, // Đặt chiều rộng cho TextField
              //   child: TextField(
              //     controller: _emailController,
              //     decoration: InputDecoration(
              //       labelText: 'Email',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(7), // Góc bo tròn
              //         borderSide: BorderSide(),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20),
              // Password Input
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
