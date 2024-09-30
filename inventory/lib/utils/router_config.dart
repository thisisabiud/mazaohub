import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory/screens/auth/login.dart';
import 'package:inventory/screens/auth/register.dart';
import 'package:inventory/screens/customers/customers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(routes: [
    //Customers routes
    GoRoute(
      path: RouteConst.customersList,
      builder: (context, state) => CustomersScreen(),
    ),

    //Auth routes
    GoRoute(
      path: RouteConst.login,
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: RouteConst.register,
      builder: (context, state) => RegistrationScreen(),
    ),
  ]);
});

class RouteConst {
  static const String customersList = '/';
  static const String addCustomer = '/customers/add';
  static const String updateCustomer = '/customers/update';

  static const String login = '/login';
  static const String register = '/register';
}
