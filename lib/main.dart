import 'package:flutter/material.dart';
import 'donation_guide_screen.dart';

void main() {
  runApp(const DonationApp());
}

class DonationApp extends StatelessWidget {
  const DonationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blood Donation App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFDFD),
        fontFamily: 'Roboto', // Ensure you have a clean sans-serif font
      ),
      home: const DonationGuideScreen(),
    );
  }
}