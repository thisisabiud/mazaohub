import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/models/sale.dart';
import 'package:inventory/models/product.dart';
import 'package:inventory/screens/sales/sales_details.dart';
import 'package:inventory/utils/providers.dart';

class SalesScreen extends ConsumerWidget {
  SalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsyncValue = ref.watch(salesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: salesAsyncValue.when(
        data: (sales) => ListView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];
            return Dismissible(
              key: Key(sale.id.toString()),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                _deleteSale(context, ref, sale.id!);
              },
              child: ListTile(
                title: Text('Sale #${sale.id}'),
                // subtitle: Text('Total: \$${.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _navigateToSaleDetail(context, sale, isEditing: true),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSale(context, ref, sale.id!),
                    ),
                  ],
                ),
                onTap: () => _navigateToSaleDetail(context, sale),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddSaleBottomSheet(context, ref),
      ),
    );
  }

  void _navigateToSaleDetail(BuildContext context, Sale sale, {bool isEditing = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SaleDetailScreen(saleId: sale.id!, isEditing: isEditing),
      ),
    );
  }

  void _showAddSaleBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('Date: '),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        _dateController.text = date.toString();
                      }
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: UnderlineInputBorder(),
              ),
              controller: _descriptionController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final db = ref.read(databaseProvider);
                final sale = Sale(
                  date: _dateController.text,
                  description: _descriptionController.text,
                );
                await db.insertSale(sale);
                ref.refresh(salesProvider);
                Navigator.pop(context);
              },
              child: const Text('Add Sale'),
            ),
          ],
        ),
      ),
    );
  }

  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _deleteSale(BuildContext context, WidgetRef ref, int id) async {
    final db = ref.read(databaseProvider);
    await db.deleteSale(id);
    ref.refresh(salesProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sale deleted successfully')),
    );
  }
}
