import 'package:client_beta/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_beta/services/flutter_secure_storage.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'App_taskbar.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final SecureStorageService _secureStorageService = SecureStorageService();
  final ApiService _apiService = ApiService('${dotenv.env['LOCALHOST']}');
  final tokenService = TokenService();
  List<dynamic> _data = [];
  bool _isLoading = true;
  String? _accessToken;
  String? _refreshToken;
  double completionPercentage = 0;
  // final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchTokens();
    _fetchProfileCompletion();
  }

  Future<void> _fetchTokens() async {
    // Lấy access token và refresh token từ TokenService
    String? accessToken = await tokenService.getValidAccessToken();
    String? refreshToken = await _secureStorageService.getRefreshToken();

    setState(() {
      _accessToken = accessToken;
      _refreshToken = refreshToken;
    });
  }

  Future<void> _fetchData() async {
    String? token = await tokenService.getValidAccessToken();
    if (token == null) {
      throw Exception('No token found');
    }

    _accessToken = token;
    final response = await http.get(
      Uri.parse('${dotenv.env['LOCALHOST']}/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchProfileCompletion() async {
    // String? token = await _secureStorageService.getToken();
    String? token = await tokenService.getValidAccessToken();
    if (token != null) {
      // Kiểm tra nếu token không phải là null
      double? completion = await _apiService.getProfileCompletionbytoken(token);
      if (completion != null) {
        setState(() {
          completionPercentage = completion; // Cập nhật tỷ lệ hoàn thành
        });
      }
    } else {
      print('Token is null. Unable to fetch profile completion.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Screen'),
      ),
      drawer: _accessToken != null ? AppTaskbar(token: _accessToken!) : null,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                //Progress Completion
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity, // Đặt kích thước chiều rộng đầy đủ
                    padding: EdgeInsets.all(16.0), // Padding bên trong khung
                    decoration: BoxDecoration(
                      color: Colors.white, // Màu nền của khung
                      borderRadius: BorderRadius.circular(12.0), // Bo góc
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3), // Màu đổ bóng
                          spreadRadius: 4,
                          blurRadius: 8,
                          offset: Offset(0, 3), // Độ lệch của bóng
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade300, // Màu viền
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hoàn thành thông tin: ${completionPercentage.toStringAsFixed(0)}%',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                            height: 8.0), // Khoảng cách giữa chữ và thanh %
                        LinearProgressIndicator(
                          value: completionPercentage / 100,
                          backgroundColor:
                              Colors.grey[300], // Màu nền của thanh %
                          color: Colors.blue, // Màu của thanh %
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_data[index]['username']),
                        subtitle: Text(_data[index]['password']),
                      );
                    },
                  ),
                ),
                if (_accessToken != null && _refreshToken != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Access Token: $_accessToken',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Refresh Token: $_refreshToken',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DataScreen(),
  ));
}
