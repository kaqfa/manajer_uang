import 'package:flutter/material.dart';
import 'package:man_uang/pages/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finance App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: LoginPage(), // Set halaman login sebagai halaman utama
    );
  }
}
