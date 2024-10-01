import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferenceProvider extends StateNotifier<SharedPreferences?> {
//   SharedPreferenceProvider() : super(null) {
//     _init();
//   }

//   Future<void> _init() async {
//     final prefs = await SharedPreferences.getInstance();
//     state = prefs;
//   }

//   Future<bool> setString(String key, String value) async {
//     if (state == null) return false;
//     return state!.setString(key, value);
//   }

//   Future<String?> getString(String key) async {
//     if (state == null) return null;
//     return state!.getString(key);
//   }

// }

// final sharedPreferencesProvider =
//     StateNotifierProvider<SharedPreferenceProvider, SharedPreferences?>(
//   (ref) => SharedPreferenceProvider(),
// );

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs;
});
