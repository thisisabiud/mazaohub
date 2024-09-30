import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory/services/auth_service.dart';
import 'package:inventory/utils/router_config.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authStateProvider.notifier).login(_username, _password);
      context.go(RouteConst.customersList);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.go(RouteConst.customersList),
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Login'),
      ),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter valid email' : null,
                      onSaved: (newValue) => _username = newValue!,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter password' : null,
                      onSaved: (newValue) => _password = newValue!,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ElevatedButton(
                        onPressed: _handleSubmit, child: const Text('Login'))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
