import '../models/transaction.dart';

final List<Category> categories = [
  Category(id: 1, name: 'Makanan'),
  Category(id: 2, name: 'Transportasi'),
  Category(id: 3, name: 'Hiburan'),
  Category(id: 4, name: 'Kesehatan'),
  Category(id: 5, name: 'Lainnya'),
];

final List<Transaction> transaction_dummy = [
  Transaction(
    id: 1,
    amount: 500000,
    description: "Gaji bulanan",
    type: "1",
    category: categories[0],
    transactionDate: DateTime.now(),
  ),
  Transaction(
    id: 2,
    amount: 200000,
    description: "Belanja kebutuhan keluarga",
    type: "2",
    category: categories[1],
    transactionDate: DateTime.now().subtract(Duration(days: 1)),
  ),
  Transaction(
    id: 3,
    amount: 300000,
    description: "Bonus",
    type: "1",
    category: categories[2],
    transactionDate: DateTime.now().subtract(Duration(days: 2)),
  ),
  Transaction(
    id: 4,
    amount: 150000,
    description: "Makan",
    type: "2",
    category: categories[0],
    transactionDate: DateTime.now().subtract(Duration(days: 3)),
  ),
];
