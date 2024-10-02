import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/utils/providers.dart';

class CustomerDetailsScreen extends ConsumerWidget {
  final int customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerAsyncValue = ref.watch(customerDetailsProvider(customerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Customer Details')),
      body: customerAsyncValue.when(
        data: (customer) {
          if (customer == null) {
            return const Center(child: Text('Customer not found'));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${customer.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Email: ${customer.email}'),
                          Text('TIN: ${customer.tin}'),
                          Text('Address: ${customer.address}'),
                          Text('Phone: ${customer.phoneNumber}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
  
}
