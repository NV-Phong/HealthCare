import 'package:client_beta/screens/register_view.dart';
import 'package:flutter/material.dart';
import 'screens/Login-Screen.dart'; // Đảm bảo rằng bạn đã import file login.dart

import 'routes/Routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
