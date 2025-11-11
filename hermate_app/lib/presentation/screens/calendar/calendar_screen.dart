import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cycle Calendar"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text(
          "Calendar will appear here soon 🌷",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
