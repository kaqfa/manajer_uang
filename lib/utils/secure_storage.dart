import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';

class SecureStorageService {
  final storage = FlutterSecureStorage();

  Future<void> saveAccessToken(String token, num expirationTime) async {
    await storage.write(key: 'access_token', value: token);
    await storage.write(
      key: 'access_token_expiration',
      value: expirationTime.toString(),
    );
  }

  Future<void> saveRefreshToken(String token) async {
    await storage.write(key: 'refresh_token', value: token);
  }

  Future<void> saveUser(User user) async {
    String userstr = jsonEncode(user.toJson());
    print(userstr);
    await storage.write(key: 'user_active', value: userstr);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: 'access_token');
  }

  Future<int?> getAccessTokenExpiration() async {
    final expirationTimeStr = await storage.read(
      key: 'access_token_expiration',
    );
    return expirationTimeStr != null ? int.parse(expirationTimeStr) : null;
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: 'refresh_token');
  }

  Future<User?> getUser() async {
    String? jsonUser = await storage.read(key: 'user_active');
    if (jsonUser != null) {
      return User.fromJson(jsonDecode(jsonUser));
    }
    return null;
  }

  Future<void> deleteAccessToken() async {
    await storage.delete(key: 'access_token');
    await storage.delete(key: 'access_token_expiration');
  }

  Future<void> deleteRefreshToken() async {
    await storage.delete(key: 'refresh_token');
  }

  Future<void> deleteAllTokens() async {
    await storage.deleteAll();
  }
}
