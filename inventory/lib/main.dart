import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory/screens/auth/login.dart';
import 'package:inventory/screens/customers/customers.dart';
import 'package:inventory/services/auth_state.dart';
import 'package:inventory/utils/router_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  
  sqfliteFfiInit();  
  databaseFactory = databaseFactoryFfi;
  
  await dotenv.load(fileName: ".env");
  
  final container = ProviderContainer();
  await container.read(authProvider.notifier).checkAuth();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyAppWithAnimation(),
    ),
  );
}

class MyAppWithAnimation extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      home: FadeIndexedStack(
        index: authState.isAuthenticated ? 1 : 0,
        children: [
          LoginScreen(),
          CustomerListScreen(),
        ],
      ),
    );
  }
}

class FadeIndexedStack extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const FadeIndexedStack({
    Key? key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  _FadeIndexedStackState createState() => _FadeIndexedStackState();
}

class _FadeIndexedStackState extends State<FadeIndexedStack> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
  }

  @override
  void didUpdateWidget(FadeIndexedStack oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}


// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final router = ref.watch(routerProvider);
//     return MaterialApp.router(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
//         useMaterial3: true,
//         primaryColorLight: const Color.fromARGB(255, 255, 255, 255),
//       ),
//       routerConfig: router,
//     );
//   }
// }
