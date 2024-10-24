import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_beta/services/flutter_secure_storage.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserProfile createState() => _UserProfile();
}

class _UserProfile extends State<UserInfo> {
  final SecureStorageService _secureStorageService = SecureStorageService();
  Map<String, dynamic>? userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    String? token = await _secureStorageService.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('${dotenv.env['LOCALHOST']}/user/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load user info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text('No user data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfoRow('Username', userData!['username']),
                      _buildUserInfoRow('Email', userData!['email']),
                      _buildUserInfoRow('Gender', userData!['gender']),
                      _buildUserInfoRow('Birth of Date',
                          userData!['birthOfDate'] ?? 'Not provided'),
                      _buildUserAvatar(userData!['avatar']),
                      SizedBox(height: 20),
                      // Nút Cập Nhật Thông Tin
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/update');
                          },
                          child: Text('Cập Nhật Thông Tin'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(String avatarUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(avatarUrl),
        ),
      ),
    );
  }
}
