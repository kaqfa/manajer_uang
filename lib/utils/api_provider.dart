import 'dart:convert';

import 'package:man_uang/models/transaction.dart';
import 'package:man_uang/models/user.dart';
import 'package:man_uang/utils/api_services.dart';
import 'package:man_uang/utils/secure_storage.dart';

class APIProvider {
  final SecureStorageService _storage = SecureStorageService();
  final ApiService _api = ApiService();

  Future<User> getProfile() async {
    final response = await _api.fetchData('profile');
    Map<String, dynamic> userJson = jsonDecode(response.body);
    return User(
      id: userJson['id'],
      username: userJson['username'],
      firstname: userJson['first_name'],
      lastname: userJson['last_name'],
    );
  }

  Future<List<Category>> getCategories() async {
    final response = await _api.fetchData('category');
    // print(response.body);
    List<dynamic> data = jsonDecode(response.body);
    List<Category> categories =
        data.map((json) => Category.fromJson(json)).toList();
    return categories;
  }

  Future<void> addTransaction(Transaction trans) async {
    final jsondata = trans.toJson();
    print(jsonEncode(jsondata));
    final response = await _api.postData('transaction', jsondata);
    print(response.body);
  }

  Future<List<Transaction>> getTransactions() async {
    final response = await _api.fetchData('transaction');
    print(response.body);
    List<dynamic> data = jsonDecode(response.body)['items'];
    List<Transaction> trans =
        data.map((json) => Transaction.fromJson(json)).toList();

    return trans;
  }
}
