import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthState {
  final bool isAuthenticated;
  final String? username;

  const AuthState({required this.isAuthenticated, this.username});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isAuthenticated: false, username: "Anonymous"));

  final apiUrl = dotenv.env["API_BASE_URL"]!;

  Future<void> login(String username, String password) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final response = await http.post(Uri.parse("${apiUrl}login"),
          body: {"email": username, "password": password});
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (responseData["success"] == true) {
        await prefs.setInt("userId", responseData["user"]["id"]);
        await prefs.setBool('isAuthenticated', true);
        await prefs.setString('username', responseData["user"]["name"]);
        state = AuthState(
            isAuthenticated: true, username: responseData["user"]["name"]);
      } else {
        state = const AuthState(isAuthenticated: true, username: "Anonymous");
      }
    }
    //allow login without credentials
    else {
      state = const AuthState(isAuthenticated: true, username: "Anonymous");
    }
  }
  

  Future<void> register({
    required String name,
    required String referenceNo,
    required String address,
    required String email,
    required String phone,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse("${apiUrl}register"),
      body: jsonEncode({
        'name': name,
        'reference_no': referenceNo,
        'address': address,
        'email': email,
        'phone': phone,
        'register_as': 'D',
        'password': password,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (responseData['success']) {
      await prefs.setBool('isAuthenticated', true);
      await prefs.setInt('userId', responseData["user"]["id"]);
      await prefs.setString('username', responseData["user"]["name"]);

      state = AuthState(
        isAuthenticated: true,
        username: responseData["user"]["name"],
      );
    }
  }
  

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('username');
    state = AuthState(isAuthenticated: false, username: 'Anonymous');
  }

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    final username = prefs.getString('username');
    state = AuthState(isAuthenticated: isAuthenticated, username: username);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

