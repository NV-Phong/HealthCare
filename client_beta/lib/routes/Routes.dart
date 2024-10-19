import 'package:client_beta/screens/Login-Screen.dart';
import 'package:client_beta/screens/Register.dart';
import 'package:client_beta/screens/TestData.dart';
import 'package:flutter/material.dart';
import '../screens/Login.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String testdata = '/testdata';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => Login(),
      register: (context) => RegisterPage(),
      testdata: (context) => DataScreen()
    };
  }
}
