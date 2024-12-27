import 'package:flutter/material.dart';
import 'package:man_uang/components/formater.dart';
import 'package:man_uang/models/transaction.dart';
import 'package:man_uang/models/user.dart';
import 'package:man_uang/pages/login_page.dart';
import 'package:man_uang/pages/transaction_form.dart';
import 'package:man_uang/utils/api_provider.dart';
import 'package:man_uang/utils/secure_storage.dart';

import '../components/transaction_item.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key, required this.user});
  final User user;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final SecureStorageService storage = SecureStorageService();
  final APIProvider api = APIProvider();

  int saldo = 0;

  List<Transaction> transactions = [];

  _DashboardPageState();

  Future<void> getTransactions() async {
    api.getTransactions().then((trans) {
      setState(() {
        this.transactions = trans;
        this.saldo = trans.fold(0, (int saldoAwal, Transaction record) {
          if (record.type == '1') {
            return saldoAwal + record.amount;
          } else {
            return saldoAwal - record.amount;
          }
        });
      });
    });
  }

  void logout() async {
    storage.deleteAllTokens();
  }

  Future<void> setUser() async {
    User? auser = await storage.getUser();
    auser ??= await api.getProfile();
  }

  @override
  void initState() {
    super.initState();
    setUser();
    getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TransactionForm()),
          ).whenComplete(() => getTransactions());
          // getTransactions();
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
                logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              } else if (value == 'action') {
                print("aksi berjalan");
                api.getCategories();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(value: 'logout', child: Text('Logout')),
                PopupMenuItem(value: 'action', child: Text("Temp Action")),
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
                        "Hai, ${widget.user.firstname} ${widget.user.lastname}",
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
