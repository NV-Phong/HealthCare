import 'package:flutter/material.dart';

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
