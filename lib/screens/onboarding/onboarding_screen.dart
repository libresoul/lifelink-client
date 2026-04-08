import 'package:flutter/material.dart';
import 'package:lifelink/data/onboarding/onboarding_page_data.dart';
import 'package:lifelink/screens/onboarding/onboarding_contact_details_page.dart';
import 'package:lifelink/screens/onboarding/onboarding_health_profile_page.dart';
import 'package:lifelink/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const int _totalPages = 5;

  double get _progressValue {
    return (_currentPage + 1) / _totalPages;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _goToHealthProfilePage() {
    _pageController.animateToPage(
      4,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 250),
                  tween: Tween<double>(begin: 0, end: _progressValue),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 6,
                      backgroundColor: const Color(0xFFE5C8CC),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFE71B34),
                      ),
                    );
                  },
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  if (index < onboardingPages.length) {
                    return OnboardingPageWidget(data: onboardingPages[index]);
                  }

                  if (index == 3) {
                    return OnboardingContactDetailsPage(
                      onContinue: _goToHealthProfilePage,
                    );
                  }

                  return const OnboardingHealthProfilePage();
                },
              ),
            ),

            // dot indicators
            if (_currentPage < onboardingPages.length)
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(onboardingPages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : const Color.fromARGB(255, 171, 171, 171),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
