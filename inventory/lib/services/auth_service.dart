import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory/models/credentials.dart';
import 'package:inventory/models/user.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  final String api_url = dotenv.get('API_BASE_URL');

  // StreamController<User?> _userController = StreamController<User?>.broadcast();
  // Stream<User?> get currentUser => _userController.stream;

  late SharedPreferences preferences;

  Future<void> login(Credentials credentials) async {
    preferences = await SharedPreferences.getInstance();
    try {
      final response = await http.post(Uri.parse("${api_url}login"),
          body: credentials.toJson());
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        preferences.setInt("userId", responseData["user"]["id"]);
        state = true;
      }
    } catch (e) {
      throw Exception('Login Failed');
    }
  }

  Future<void> signup(User user) async {
    try {
      final response =
          await http.post(Uri.parse("${api_url}register"), body: user.toJson());
      if (response.statusCode == 200) {}
    } catch (e) {
      throw Exception(e);
    }
  }

  void logout() {
    state = false;
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

final loginProvider =
    FutureProvider.family<void, Credentials>((ref, credentials) {
  final authProvider = ref.watch(authStateNotifierProvider.notifier);
  return authProvider.login(credentials);
});
