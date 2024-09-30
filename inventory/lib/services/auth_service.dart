import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(ref.read(
      sharedPreferencesProvider as ProviderListenable<SharedPreferences>)),
);

class AuthState {
  final bool isAuthenticated;

  AuthState({required this.isAuthenticated});
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final String api_url = dotenv.get('API_BASE_URL');
  final SharedPreferences _sharedPreferences;

  AuthStateNotifier(this._sharedPreferences)
      : super(AuthState(isAuthenticated: false));

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(Uri.parse("${api_url}login"),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final sessionToken = responseData['token'];
        await _sharedPreferences.setString('token', sessionToken);
        state = AuthState(isAuthenticated: true);
      }
    } catch (e) {
      throw Exception('Login Failed');
    }
  }

  void logout() async {
    await _clearSession();
    state = AuthState(isAuthenticated: false);
  }

  Future<void> _clearSession() async {
    await _sharedPreferences.remove('token');
  }
}

final sharedPreferencesProvider = FutureProvider<SharedPreferences>(
  (ref) async => await SharedPreferences.getInstance(),
);
