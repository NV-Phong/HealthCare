// import 'package:client_beta/screens/Login-Screen.dart';
import 'package:client_beta/screens/Disease_screen.dart';
import 'package:client_beta/screens/register_view.dart';
import 'package:client_beta/screens/TestData.dart';
import 'package:client_beta/screens/Profile.dart';
import 'package:client_beta/screens/Update_Info.dart';
import 'package:flutter/material.dart';
import '../screens/Login.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String testdata = '/testdata';
  static const String profile = '/profile';
  static const String update = '/update';
  static const String disease = '/disease';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => Login(),
      register: (context) => RegisterPage(),
      testdata: (context) => DataScreen(),
      profile: (context) => UserInfo(),
      update: (context) => UpdateInfo(),
      disease: (context) => Disease()
    };
  }
}
