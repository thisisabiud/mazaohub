import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/data/database.dart';
import 'package:inventory/models/customer.dart';

// Database provider
final databaseProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper.instance;
});

// Customers provider
final customersProvider = FutureProvider<List<Customer>>((ref) async {
  final db = ref.watch(databaseProvider);
  return await db.getAllCustomers();
});

// Customer details provider
final customerDetailsProvider =
    FutureProvider.family<Customer?, int>((ref, customerId) async {
  final db = ref.watch(databaseProvider);
  return await db.getCustomerById(customerId);
});

// // Customer sales provider
// final customerSalesProvider = FutureProvider.family<List<Sale>, int>((ref, customerId) async {
//   final db = ref.watch(databaseProvider);
//   return await db.getSalesByCustomerId(customerId);
// });

// // Sales provider
// final salesProvider = FutureProvider<List<Sale>>((ref) async {
//   final db = ref.watch(databaseProvider);
//   return await db.getAllSales();
// });