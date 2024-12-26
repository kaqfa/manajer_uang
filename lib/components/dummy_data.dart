import '../models/transaction.dart';

final List<String> categories = [
  'Makanan',
  'Transportasi',
  'Hiburan',
  'Kesehatan',
  'Lainnya',
];

final List<Transaction> transactions = [
  Transaction(
    amount: 500000,
    description: "Gaji bulanan",
    type: "1",
    category: "Makanan",
    date: DateTime.now(),
  ),
  Transaction(
    amount: 200000,
    description: "Belanja kebutuhan keluarga",
    type: "2",
    category: "Lainnya",
    date: DateTime.now().subtract(Duration(days: 1)),
  ),
  Transaction(
    amount: 300000,
    description: "Bonus",
    type: "1",
    category: "Hiburan",
    date: DateTime.now().subtract(Duration(days: 2)),
  ),
  Transaction(
    amount: 150000,
    description: "Makan",
    type: "2",
    category: "Kesehatan",
    date: DateTime.now().subtract(Duration(days: 3)),
  ),
];
