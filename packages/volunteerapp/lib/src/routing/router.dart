import 'package:volunteerapp/src/features/home/presentation/screens/home_screen.dart';
import 'package:volunteerapp/src/features/onboarding/presentation/screens/onboarding_home.dart';
import 'package:volunteerapp/src/features/onboarding/presentation/screens/onboarding_login.dart';
import 'package:volunteerapp/src/features/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

class Devfest2024Router {
  Devfest2024Router._();

  static final Devfest2024Router instance = Devfest2024Router._();

  static String initialRoute = HomeScreen.route;

  Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    return switch (settings.name) {
      OnboardingHomeScreen.route =>
        MaterialPageRoute(builder: (_) => const OnboardingHomeScreen()),
      OnboardingLoginScreen.route =>
        MaterialPageRoute(builder: (_) => const OnboardingLoginScreen()),
      HomeScreen.route => MaterialPageRoute(builder: (_) => const HomeScreen()),
      SearchScreen.route =>
        MaterialPageRoute(builder: (_) => const SearchScreen()),
      _ => MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        ),
    };
  }
}

extension BuildContextX on BuildContext {
  void pop<T extends Object>([T? result]) => Navigator.of(this).pop<T>(result);

  Future<dynamic> goNamed(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamed(routeName, arguments: arguments);

  Future<dynamic> goNamedAndPopAll(String routeName, {Object? arguments}) =>
      Navigator.of(this).pushNamedAndRemoveUntil(routeName, (route) => false,
          arguments: arguments);
}
