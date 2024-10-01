import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/utils/providers.dart';

class CustomerDetailsScreen extends ConsumerWidget {
  final int customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final salesFuture = ref.watch(customerSalesProvider(customerId));
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
                          Text('TIN: ${customer.TIN}'),
                          Text('Address: ${customer.address}'),
                          Text('Phone: ${customer.phone_number}'),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Sales History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                // salesFuture.when(
                //   data: (sales) {
                //     if (sales.isEmpty) {
                //       return Padding(
                //         padding: const EdgeInsets.all(16.0),
                //         child: Text('No sales records found for this customer.'),
                //       );
                //     }
                //     return ListView.builder(
                //       shrinkWrap: true,
                //       physics: NeverScrollableScrollPhysics(),
                //       itemCount: sales.length,
                //       itemBuilder: (context, index) {
                //         final sale = sales[index];
                //         return Card(
                //           child: ListTile(
                //             title: Text('Sale #${sale.id}'),
                //             subtitle: Text('Date: ${sale.date.toString().split(' ')[0]}'),
                //             trailing: Text('\$${sale.amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   loading: () => Center(child: CircularProgressIndicator()),
                //   error: (err, stack) => Center(child: Text('Error: $err')),
                // ),
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
