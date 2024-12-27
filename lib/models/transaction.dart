class Category {
  int id;
  String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json['id'] as int, name: json['name'] as String);
  }

  @override
  bool operator ==(Object other) {
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class Transaction {
  final int id;
  final int amount;
  final String description;
  final String type;
  final Category category;
  final DateTime transactionDate;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.type,
    required this.category,
    required this.transactionDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    Category cat = Category(
      id: json['category']['id'],
      name: json['category']['name'],
    );
    return Transaction(
      id: json['id'] as int,
      amount: json['amount'] as int,
      description: json['description'] as String,
      type: json['type'] as String,
      category: cat,
      transactionDate: DateTime.parse(json['transaction_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type,
      'transaction_date': transactionDate.toIso8601String(),
      'category_id': category.id,
    };
  }
}
