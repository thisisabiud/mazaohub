import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/auth_service.dart';
import 'package:inventory/utils/router_config.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late User _user;
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ref.read(authStateProvider);
      context.go(RouteConst.login);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        leading: IconButton(
            onPressed: () => context.go(RouteConst.customersList),
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Form(
                  child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Your name'),
                onSaved: (newValue) => _user.name = newValue!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (newValue) => _user.email = newValue!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone number'),
                onSaved: (newValue) => _user.phone = newValue!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (newValue) => _user.address = newValue!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reference number'),
                onSaved: (newValue) => _user.reference_no = newValue!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                onSaved: (newValue) => _user.password = newValue!,
              ),
              const SizedBox(
                height: 8.0,
              ),
              ElevatedButton(
                  onPressed: _handleSubmit, child: const Text('Register')),
            ],
          ))),
        ),
      ),
    );
  }
}
