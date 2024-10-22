import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:client_beta/services/flutter_secure_storage.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'App_taskbar.dart';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final SecureStorageService _secureStorageService = SecureStorageService();
  List<dynamic> _data = [];
  bool _isLoading = true;
  String? _token;
  // final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    String? token = await _secureStorageService.getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    _token = token;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Screen'),
      ),
      drawer: AppTaskbar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                if (_token != null) // Hiển thị token nếu tồn tại
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Token: $_token',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
