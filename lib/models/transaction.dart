class Transaction {
  final int amount;
  final String description;
  final String type;
  final String category;
  final DateTime date;

  Transaction({
    required this.amount,
    required this.description,
    required this.type,
    required this.category,
    required this.date,
  });
}
