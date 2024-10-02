import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/data/database.dart';
import 'package:inventory/models/customer.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/models/sale.dart';
import 'package:shared_preferences/shared_preferences.dart';

final databaseProvider = Provider<DatabaseHelper>((ref) => DatabaseHelper.instance);
final navigationProvider = StateProvider<String?>((ref) => null);

final usernameProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? 'Guest';
});

final customersProvider = FutureProvider<List<Customer>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.getAllCustomers();
});

final customerDetailsProvider = FutureProvider.family<Customer?, int>(
  (ref, id) async {
    final db = ref.watch(databaseProvider);
    return await db.getCustomerById(id);
  },
);

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.getAllProducts();
});

final salesProvider = FutureProvider<List<Sale>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.getAllSales();
});

final customerProvider = FutureProvider.family<Customer?, int>(
  (ref, id) async {
    final db = ref.watch(databaseProvider);
    return await db.getCustomerById(id);
  },
);

final productProvider = FutureProvider.family<Product?, int>(
  (ref, id) async {
    final db = ref.watch(databaseProvider);
    return await db.getProductById(id);
  },
);

final saleProvider = FutureProvider.family<Sale?, int>(
  (ref, id) async {
    final db = ref.watch(databaseProvider);
    return await db.getSaleById(id);
  },
);
