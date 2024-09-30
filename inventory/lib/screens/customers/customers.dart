import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory/utils/router_config.dart';

class CustomersScreen extends ConsumerWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () => context.go(RouteConst.login),
              child: const Text('Login')),
          TextButton(
              onPressed: () => context.go(RouteConst.register),
              child: const Text('Register')),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: ListView.separated(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item $index'));
            },
            separatorBuilder: (context, index) {
              return const Divider(height: 1, color: Colors.grey);
            },
          )),
    );
  }
}

class CUstomerListItem extends StatelessWidget {
  const CUstomerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: TextStyle(fontSize: 3.0),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text('demo@email.com')
          ],
        ),
      ),
    );
  }
}
