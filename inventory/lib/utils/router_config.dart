import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory/screens/auth/login.dart';
import 'package:inventory/screens/auth/register.dart';
import 'package:inventory/screens/customers/customers.dart';
import 'package:inventory/services/auth_service.dart';

// final routerProvider = Provider<GoRouter>((ref) {
//   final authStateProvider = ref.watch(authStateNotifierProvider);
//   return GoRouter(
    // routes: [
      // GoRoute(
      //   path: RouteConst.home,
      //   builder: (context, state) => HomeScreen(),
      // ),
    //   GoRoute(
    //     path: RouteConst.customers,
    //     builder: (context, state) => CustomerListScreen(),
    //   ),

    //   //Auth routes
    //   GoRoute(
    //     path: RouteConst.login,
    //     builder: (context, state) => const LoginScreen(),
    //   ),
    //   GoRoute(
    //     path: RouteConst.register,
    //     builder: (context, state) => const RegistrationScreen(),
    //   ),
    // ],
    // redirect: (context, state) =>
    //     (!authStateProvider && state.fullPath == RouteConst.login)
    //         ? RouteConst.home
    //         : null,
//   );
// });

class RouteConst {
  static const String customers = '/';
  static const String addCustomer = '/customers/add';
  static const String updateCustomer = '/customers/update';

  static const String login = '/login';
  static const String register = '/register';
}
