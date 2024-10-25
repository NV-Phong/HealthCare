import 'package:client_beta/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'dart:convert';
import '../services/api_service.dart';

class AppTaskbar extends StatefulWidget {
  final String token; // Thêm token làm tham số của widget

  AppTaskbar({required this.token});
  @override
  _TaskbarState createState() => _TaskbarState();
}

class _TaskbarState extends State<AppTaskbar> {
  final storage = FlutterSecureStorage();
  final ApiService _apiService = ApiService('${dotenv.env['LOCALHOST']}');
  final tokenService = TokenService();

  String username = '';
  String email = '';
  String avatarUrl =
      'assets/user_avatar.png'; // Đường dẫn mặc định cho ảnh đại diện
  double completionPercentage = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // Future<void> _fetchProfileCompletion() async {
  //   final token = widget.token; // Lấy token từ widget
  //   double? completion = await _apiService.getProfileCompletionbytoken(token);
  //   if (completion != null) {
  //     setState(() {
  //       completionPercentage = completion; // Cập nhật tỷ lệ hoàn thành
  //     });
  //   }
  // }

  Future<void> _fetchUserInfo() async {
    // Lấy token từ storage
    // String? token = await storage.read(key: 'authToken');
    String? token = await tokenService.getValidAccessToken();
    if (token != null) {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['LOCALHOST']}/user/profile-completion'), // Đổi endpoint nếu cần
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
    Map<String, dynamic> userInfo = Jwt.parseJwt(widget.token);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userInfo['username'] ?? 'Unknown User'),
            accountEmail: Text(userInfo['email'] ?? 'No Email'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: avatarUrl.startsWith('http')
                  ? NetworkImage(avatarUrl)
                  : AssetImage(avatarUrl) as ImageProvider,
            ),
          ),

// Hiển thị thanh % hoàn thành
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
          //   child: Column(
          //     children: [
          //       Text(
          //         'Hoàn thành thông tin: ${completionPercentage.toStringAsFixed(0)}%',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //       SizedBox(height: 8.0),
          //       LinearProgressIndicator(
          //         value: completionPercentage /
          //             100, // Chia cho 100 để lấy giá trị từ 0.0 đến 1.0
          //         backgroundColor: Colors.grey[300],
          //         color: Colors.blue, // Màu của thanh tiến độ
          //       ),
          //     ],
          //   ),
          // ),

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
