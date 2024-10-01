import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class CustomerService {
  Future<List<Customer>> getCustomersById();
  Future<bool> addCustomer(Customer customer);
  Future<bool> updateCustomer(Customer customer);
  Future<bool> deleteCustomer();
}

class CustomerRepository implements CustomerService {
  final api_url = dotenv.env["API_BASE_URL"];
  late SharedPreferences preferences;

  @override
  Future<bool> addCustomer(Customer customer) async {
    customer.id = preferences.getInt("userId");

    final response = await http.post(
        Uri.parse("${api_url}ema/pos/get_client/save"),
        body: jsonEncode(customer));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteCustomer() {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<List<Customer>> getCustomersById() async {
    preferences = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        "${api_url}ema/pos/get_client/${preferences.getInt("userId")}/index"));
    final responseData = jsonDecode(response.body) as Map<String, dynamic>;
    final customerList = responseData['client'] as List;
    final customers = customerList.map((data) => Customer.fromJson(data)).toList();
    return customers;
  }

  @override
  Future<bool> updateCustomer(Customer customer) {
    // TODO: implement updateCustomer
    throw UnimplementedError();
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});

final addCustomerProvider =
    FutureProvider.family<bool, Customer>((ref, customer) {
  final customerRepo = ref.watch(customerRepositoryProvider);
  return customerRepo.addCustomer(customer);
});
