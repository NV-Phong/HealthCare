import 'package:client/screens/login_screen.dart';
import 'package:flutter/material.dart';

class HomeRoutes {
  static const String login = '/';
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const Login(),
    };
  }
}
