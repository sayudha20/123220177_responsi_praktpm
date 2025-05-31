import 'package:flutter/material.dart';
import 'package:responsi_123220177/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsi_123220177/pages/home_page.dart';
import 'package:responsi_123220177/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final username = prefs.getString('username');

  // Validasi username yang tersimpan
  final isValidUser = username == AuthService.validUsername;

  runApp(MyApp(isLoggedIn: isLoggedIn && isValidUser));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smartphone Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isLoggedIn ? HomePage() : LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
