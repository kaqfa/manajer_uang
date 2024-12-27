import 'package:flutter/material.dart';
import 'package:man_uang/components/our_button.dart';
import 'package:man_uang/utils/api_services.dart';
import 'package:man_uang/utils/secure_storage.dart';

import '../models/user.dart';
import 'dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController firstnameCtrl = TextEditingController();
  final TextEditingController lastnameCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmCtrl = TextEditingController();

  final ApiService api = ApiService();
  final SecureStorageService storage = SecureStorageService();

  void register() async {
    final response = await api.register(
      usernameCtrl.text,
      firstnameCtrl.text,
      lastnameCtrl.text,
      passwordCtrl.text,
      confirmCtrl.text,
    );
    if (response.statusCode == 200) {
      await api.login(usernameCtrl.text, passwordCtrl.text);
      User? user = await storage.getUser();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage(user: user!)),
        (route) => false,
      );
    } else {
      print(response.body);
      throw Exception("Registrasi gagal");
    }
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
                'Register',
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
                controller: firstnameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Depan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: lastnameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Belakang',
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
              SizedBox(height: 10),
              TextField(
                controller: confirmCtrl,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              OurButton(
                onPressed: () {
                  print("aksi daftar");
                  register();
                },
                title: "Daftar",
                size: 20,
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Sudah punya akun? Login di sini'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
