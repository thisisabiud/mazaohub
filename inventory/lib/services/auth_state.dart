import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isAuthenticated;
  final String? username;

  AuthState({required this.isAuthenticated, this.username});
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isAuthenticated: false));

  Future<void> login(String username, String password) async {
    // Here you would typically validate credentials against a backend
    // For this example, we'll just check if the username and password are not empty
    if (username.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('username', username);
      state = AuthState(isAuthenticated: true, username: username);
    }
  }

  Future<void> register(String username, String password) async {
    // Here you would typically send registration data to a backend
    // For this example, we'll just store the username
    if (username.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('username', username);
      state = AuthState(isAuthenticated: true, username: username);
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
