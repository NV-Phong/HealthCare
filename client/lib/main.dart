import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/home_route.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HealthCare',
      initialRoute: HomeRoutes.login,
      routes: HomeRoutes.routes,
    );
  }
}
