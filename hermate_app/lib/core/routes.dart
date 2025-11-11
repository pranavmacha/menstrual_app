import 'package:flutter/material.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/calendar/calendar_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/calendar':
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 — Page Not Found'))),
        );
    }
  }
}
