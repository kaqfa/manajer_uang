import 'package:flutter/material.dart';
import 'package:man_uang/components/formater.dart';
import 'package:man_uang/pages/login_page.dart';
import 'package:man_uang/pages/transaction_form.dart';

import '../components/dummy_data.dart';
import '../components/transaction_item.dart';

class DashboardPage extends StatelessWidget {
  final int saldo = 1500000;
  final String username = "John Doe";
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionForm()),
          );
        },
        child: Icon(Icons.add_circle_rounded),
      ),
      appBar: AppBar(
        title: Text(
          'Beranda Keuangan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
              ];
            },
          ),
        ],
        backgroundColor: Color(0xFF388E3C), // Hijau tua
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xFFE0F7E0)),
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF629864), Color(0xFFE0F7E0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hai, $username",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '"Jangan menunggu. Waktu tidak akan pernah tepat."',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'Daftar Transaksi',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return TransactionItem(transaction: transactions[index]);
                    },
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    formatRupiah(saldo),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F3310),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
