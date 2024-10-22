import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';

class AppTaskbar extends StatefulWidget {
  @override
  _TaskbarState createState() => _TaskbarState();
}

class _TaskbarState extends State<AppTaskbar> {
  final storage = FlutterSecureStorage();
  final ApiService _apiService = ApiService('${dotenv.env['LOCALHOST']}');
  String username = '';
  String email = '';
  String avatarUrl =
      'assets/user_avatar.png'; // Đường dẫn mặc định cho ảnh đại diện

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    // Lấy token từ storage
    String? token = await storage.read(key: 'authToken');

    if (token != null) {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['LOCALHOST']}/user/profile'), // Đổi endpoint nếu cần
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          username = userData['username'] ?? 'Người dùng';
          email = userData['email'] ?? 'email@example.com';
          // Giả sử trường avatar chứa đường dẫn URL của ảnh
          if (userData['avatar'] != null && userData['avatar'].isNotEmpty) {
            avatarUrl = userData['avatar'];
          }
        });
      } else {
        print('Failed to fetch user info');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(username),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: avatarUrl.startsWith('http')
                  ? NetworkImage(avatarUrl)
                  : AssetImage(avatarUrl) as ImageProvider,
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Thông tin cá nhân'),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () async {
              await _apiService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
