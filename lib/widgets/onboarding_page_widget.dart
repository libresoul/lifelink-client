import 'package:flutter/material.dart';
import 'package:lifelink/screens/onboarding/onboarding_page_data.dart';

class OnboardingPageWidget extends StatelessWidget{
  final OnboardingPageData data;
  const OnboardingPageWidget ({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data.mainTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          Image.asset(
            data.imagePath,
            height: 260,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 15),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color:Color.fromARGB(255, 83, 83, 83),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              data.subtitle,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 87, 86, 86),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
}}