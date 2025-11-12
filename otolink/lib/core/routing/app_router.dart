import 'package:flutter/material.dart';

import 'app_routes.dart';
import '../../features/home/views/home_view.dart';
import '../../features/splash/views/splash_view.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _material(const SplashView());
      case AppRoutes.home:
        return _material(const HomeView());
      default:
        return _material(
          _UnknownRouteView(name: settings.name ?? 'unknown'),
        );
    }
  }

  static MaterialPageRoute _material(Widget child) => MaterialPageRoute(builder: (_) => child);

  static Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(String routeName, {Object? arguments, TO? result}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, TO>(routeName, arguments: arguments, result: result);
  }

  static void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState!.pop<T>(result);
  }
}

class _UnknownRouteView extends StatelessWidget {
  const _UnknownRouteView({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Not Found')),
      body: Center(
        child: Text('No route defined for "$name"'),
      ),
    );
  }
}
