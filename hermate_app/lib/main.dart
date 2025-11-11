import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/constants/colors.dart';

void main() {
  runApp(const MenstrualApp());
}

class MenstrualApp extends StatelessWidget {
  const MenstrualApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HerTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      initialRoute: '/onboarding',
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
