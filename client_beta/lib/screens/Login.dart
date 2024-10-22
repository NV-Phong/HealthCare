import 'package:client_beta/services/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
// Nhớ import API Service

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // final SharedPreferencesService _sharedPreferencesService =
  //     SharedPreferencesService();
  final SecureStorageService _secureStorageService = SecureStorageService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService =
      ApiService('http://localhost:3000'); // Địa chỉ API của bạn

  Future<void> _login() async {
    final username = _usernameController.text;
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
              const EdgeInsets.all(16.0), // Add some padding for better layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome to the Login Page!'),
              SizedBox(height: 20),

              // Username Input
              Container(
                width: 300, // Set the width of the TextField
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // Rounded corners
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Password Input
              Container(
                width: 300, // Set the width of the TextField
                child: TextField(
                  controller: _passwordController,
                  obscureText: true, // This hides the input text
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7), // Rounded corners
                      borderSide: BorderSide(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _login, // Gọi API khi bấm nút đăng nhập
                child: Text('Login'),
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/testdata');
                },
                child: Text('Test Data'),
              ),
              SizedBox(height: 10),

              // Optionally, a button for registration
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
