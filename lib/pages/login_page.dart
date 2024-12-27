import 'package:flutter/material.dart';
import 'package:man_uang/pages/register_page.dart';
import 'package:man_uang/utils/api_services.dart';
import 'package:man_uang/utils/secure_storage.dart';

import '../components/our_button.dart';
import '../models/user.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService api = ApiService();

  final SecureStorageService _storage = SecureStorageService();

  final TextEditingController usernameCtrl = TextEditingController();

  final TextEditingController passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkActiveUser();
  }

  void checkActiveUser() async {
    User? user = await _storage.getUser();
    if (user != null) {
      goToDashboard(user);
    }
  }

  void goToDashboard(User user) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage(user: user)),
      (route) => false,
    );
  }

  Future<void> _login() async {
    User? user = await api.login(usernameCtrl.text, passwordCtrl.text);
    goToDashboard(user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFFE0F7E0)),
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: usernameCtrl,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordCtrl,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              OurButton(
                title: 'Login',
                size: 20,
                onPressed: () {
                  try {
                    _login();
                    // goToDashboard();
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Login gagal")));
                  }
                },
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Belum punya akun? Daftar di sini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
