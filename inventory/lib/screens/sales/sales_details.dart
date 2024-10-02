import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/models/sale.dart';
import 'package:inventory/utils/providers.dart';

class SaleDetailScreen extends ConsumerWidget {
  final int saleId;
  final bool isEditing;

  const SaleDetailScreen({super.key, required this.saleId, this.isEditing = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleAsyncValue = ref.watch(saleProvider(saleId));

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Sale' : 'Sale Details'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => _updateSale(context, ref),
            ),
        ],
      ),
      body: saleAsyncValue.when(
        data: (sale) => sale == null
            ? const Center(child: Text('Sale not found'))
            : _buildSaleDetail(context, ref, sale),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildSaleDetail(BuildContext context, WidgetRef ref, Sale sale) {
    final customerAsyncValue = ref.watch(customerProvider(sale.id!));
    final productsAsyncValue = ref.watch(saleProvider(saleId));

    if (!isEditing) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sale ID: ${sale.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Date: ${sale.date}'),
            const SizedBox(height: 16),
            Text('Description: ${sale.description}'),
            const SizedBox(height: 16),
            Text('Total: \$${20.000.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    } else {
      return Form(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
              initialValue: sale.description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Product name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Price must be a number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Quantity must be an integer';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement add product logic here
                
              },              child: const Text('Add Product'),
            ),
            const SizedBox(height: 16),
            productsAsyncValue.when(
              data: (products) => products == null
                  ? const Text('No products')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sale?.products.length,
                      itemBuilder: (context, index) {
                        final product = sale.products[index];
                        return ListTile(
                          title: const Text('Changes'),
                          subtitle: Text('Quantity: ${product?.quantity.toString()}'),
                          trailing: Text('\$${(product!.price * product.quantity).toStringAsFixed(2)}'),
                        );
                      },
                    ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => Text('Error loading products: $error'),
            ),
            const SizedBox(height: 16),
            Text('Total: \$${20.00.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      );
    }
  }

  void _updateSale(BuildContext context, WidgetRef ref) {
    // Implement update logic here
    // You might want to show a dialog to confirm the update
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sale updated successfully')),
    );
    Navigator.pop(context);
  }
}
