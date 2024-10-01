import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthState {
  final bool isAuthenticated;
  final String? username;

  AuthState({required this.isAuthenticated, this.username});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  final api_url = dotenv.env["API_BASE_URL"];

  Future<void> login(String username, String password) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final response = await http.post(Uri.parse("${api_url}login"),
          body: {"email": username, "password": password});
      final responseData = jsonDecode(response.body);
      prefs.setInt("userId", responseData["user"]["id"]);
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('username', responseData["user"]["name"]);
      state = AuthState(
          isAuthenticated: true, username: responseData["user"]["name"]);
    }
  }

  Future<void> register(
      {required String name,
      required String reference_no,
      required String address,
      required String email,
      required String phone,
      required String password}) async {
    if (name.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final result = await http.post(Uri.parse("${api_url}register"), body: {
        "name": name,
        "reference_no": reference_no,
        "address": address,
        "email": email,
        "phone": phone,
        "register_as": "D",
        "password": password
      });
      final response = jsonDecode(result.body);
      await prefs.setBool('isAuthenticated', true);
      await prefs.setInt('userId', response["user"]["id"]);
      await prefs.setString('username', response["user"]["name"]);
      state =
          AuthState(isAuthenticated: true, username: response["user"]["name"]);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', false);
    await prefs.remove('username');
    state = AuthState(isAuthenticated: false);
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
