import 'package:flutter/material.dart';
import 'package:training_app/screens/settings.dart';

import '../screens/forgotten_password.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/pre_login.dart';
import '../screens/register.dart';
import '../screens/splash.dart';
import 'routes.dart';

abstract class BVRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    final Object? routeArguments = routeSettings.arguments;

    switch (routeSettings.name) {
      case BVRoutes.initial:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case BVRoutes.preLogin:
        return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: BVRoutes.preLogin),
          builder: (BuildContext context) => const PreLoginScreen(),
        );
      case BVRoutes.register:
        return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: BVRoutes.register),
          builder: (BuildContext context) => const RegisterScreen(),
        );

      case BVRoutes.login:
        return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: BVRoutes.login),
          builder: (BuildContext context) => const LoginScreen(),
        );

      case BVRoutes.forgottenPassword:
        return MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const ForgottenPasswordScreen(),
        );

      case BVRoutes.home:
        return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: BVRoutes.home),
          builder: (BuildContext context) => const HomeScreen(),
        );
      case BVRoutes.settings:
        return MaterialPageRoute<dynamic>(
          settings: const RouteSettings(name: BVRoutes.settings),
          builder: (BuildContext context) => const SettingScreen(),
        );
    }

    return null;
  }
}
