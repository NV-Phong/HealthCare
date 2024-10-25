import 'package:client_beta/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:client_beta/services/api_service.dart';
import 'package:client_beta/services/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert'; // Thêm import này để sử dụng json.decode
import 'package:http/http.dart' as http;

class UpdateInfo extends StatefulWidget {
  @override
  _UpdateProfile createState() => _UpdateProfile();
}

class _UpdateProfile extends State<UpdateInfo> {
  final _formKey = GlobalKey<FormState>();
  final SecureStorageService _secureStorageService = SecureStorageService();
  final ApiService _apiService =
      ApiService('${dotenv.env['LOCALHOST']}'); // URL API của bạn
  final tokenService = TokenService();

  String? _username;
  String? _email;
  String? _birthOfDate;
  String? _gender;
  String? _avatar;
  String? _token;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserToken();
    _fetchUserInfo(); // Gọi phương thức này để lấy thông tin người dùng
  }

  Future<void> _fetchUserToken() async {
    // _token = await _secureStorageService.getToken();
    _token = await tokenService.getValidAccessToken();
  }

  Future<void> _fetchUserInfo() async {
    // _token = await _secureStorageService.getToken();
    _token = await tokenService.getValidAccessToken();

    if (_token == null) return;

    final response = await http.get(
      Uri.parse('${dotenv.env['LOCALHOST']}/user/profile'),
      headers: {
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      final userInfo = json.decode(response.body);
      setState(() {
        _username = userInfo['username'];
        _email = userInfo['email'];
        _birthOfDate = userInfo['birthOfDate'];
        _gender = userInfo['gender'];
        _avatar = userInfo['avatar'];
        _isLoading = false;
      });
    } else {
      print("Failed to load user info");
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_token == null) {
        print("Token is missing");
        return;
      }

      final updatedUserData = {
        'username': _username,
        'email': _email,
        'birthOfDate': _birthOfDate,
        'gender': _gender,
        'avatar': _avatar,
      };

      try {
        final response = await http.put(
          Uri.parse('${dotenv.env['LOCALHOST']}/user/update'),
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
          body: json.encode(updatedUserData),
        );

        if (response.statusCode == 200) {
          Navigator.pushNamed(
              context, '/profile'); // Chuyển hướng đến trang hồ sơ
        } else {
          print("Failed to update user: ${response.body}");
        }
      } catch (error) {
        print("Failed to update user: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cập Nhật Thông Tin Người Dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                initialValue: _username,
                onSaved: (value) => _username = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                initialValue: _email,
                onSaved: (value) => _email = value,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Ngày sinh (yyyy-mm-dd)',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthOfDate =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
                controller: TextEditingController(text: _birthOfDate),
                onSaved: (value) => _birthOfDate = value,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Giới tính'),
                value: _gender,
                items: [
                  DropdownMenuItem(child: Text('Nam'), value: 'male'),
                  DropdownMenuItem(child: Text('Nữ'), value: 'female'),
                  DropdownMenuItem(child: Text('Khác'), value: 'other'),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                onSaved: (value) => _gender = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Link ảnh đại diện'),
                initialValue: _avatar,
                onSaved: (value) => _avatar = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: Text('Cập Nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
