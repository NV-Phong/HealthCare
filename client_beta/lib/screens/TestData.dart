// import 'package:client_beta/services/api_service.dart';
import 'package:client_beta/services/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final SecureStorageService _secureStorageService = SecureStorageService();
  List<dynamic> _data = [];
  bool _isLoading = true;
  // final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // final ApiService _apiService = ApiService();
    String? token = await _secureStorageService.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('http://localhost:3000/user'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Screen'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.logout),
        //     onPressed: () async {
        //       await _apiService.logout(context); // Gọi phương thức logout
        //   ),
        // ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_data[index]['username']),
                  subtitle: Text(_data[index]['password']),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DataScreen(),
  ));
}
