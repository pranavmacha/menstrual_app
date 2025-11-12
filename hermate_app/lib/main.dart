import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/constants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('cycleData'); // open our local storage box
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
