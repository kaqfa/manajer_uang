import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:man_uang/models/user.dart';
import 'package:man_uang/utils/secure_storage.dart';

class ApiService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';
  final SecureStorageService _storageService = SecureStorageService();

  Future<http.Response> register(
    String username,
    String firstname,
    String lastname,
    String password,
    String confirm,
  ) async {
    String json = jsonEncode(<String, String>{
      'username': username,
      'password': password,
      'confirm_password': confirm,
      'first_name': firstname,
      'last_name': lastname,
    });
    print(json);
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json,
    );

    return response;
  }

  Future<User?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/sign-in'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final accessToken = data['access'];
      final refreshToken = data['refresh'];
      final expiresIn = 250; // 5 menit

      final expirationTime =
          DateTime.now().millisecondsSinceEpoch + (expiresIn * 1000);
      await _storageService.saveAccessToken(accessToken, expirationTime);
      await _storageService.saveRefreshToken(refreshToken);

      final respProfile = await fetchData('profile');
      if (respProfile.statusCode == 200) {
        Map<String, dynamic> jsonuser = jsonDecode(respProfile.body);
        await _storageService.saveUser(User.fromJson(jsonuser));
        User? user = await _storageService.getUser();
        return user;
      }
    } else {
      throw Exception('Login gagal');
    }
  }

  Future<void> refreshTokenAndRetry() async {
    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('Token refresh tidak ditemukan');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/token-refresh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access'];
      final newExpiresIn = 250; // 5 menit

      final newExpirationTime =
          DateTime.now().millisecondsSinceEpoch + (newExpiresIn * 1000);
      await _storageService.saveAccessToken(newAccessToken, newExpirationTime);
    } else {
      throw Exception('Failed to refresh token');
    }
  }

  Future<http.Response> fetchData(String endpoint) async {
    final accessToken = await _storageService.getAccessToken();
    final expirationTime = await _storageService.getAccessTokenExpiration();

    if (accessToken == null ||
        expirationTime == null ||
        DateTime.now().millisecondsSinceEpoch >= expirationTime) {
      await refreshTokenAndRetry();
    }
    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    return response;
  }

  Future<http.Response> postData(
    String endpoint,
    Map<String, dynamic> payload,
  ) async {
    final accessToken = await _storageService.getAccessToken();
    final expirationTime = await _storageService.getAccessTokenExpiration();

    if (accessToken == null ||
        expirationTime == null ||
        DateTime.now().millisecondsSinceEpoch >= expirationTime) {
      await refreshTokenAndRetry();
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      body: jsonEncode(payload),
    );

    return response;
  }
}
