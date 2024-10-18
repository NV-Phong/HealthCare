import 'package:client_beta/screens/Register.dart';
import 'package:flutter/material.dart';
import '../screens/Login.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/Register';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => Login(),
      register: (context) => RegisterPage(),
    };
  }
}
