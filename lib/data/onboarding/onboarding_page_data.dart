class OnboardingPageData {
  final String mainTitle;
  final String imagePath;
  final String title;
  final String subtitle;

  const OnboardingPageData({
    required this.mainTitle,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });
}

final List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    mainTitle:'Welcome to LifeLink',
    imagePath: 'assets/images/onboarding_1.png',
    title: 'Hassle free donations',
    subtitle: 'Help save lives. Your blood values more than you think',
  ),
  OnboardingPageData(
    mainTitle:'Find nearby campaigns',
    imagePath: 'assets/images/onboarding_2.png',
    title: 'Donate Close to You',
    subtitle: 'Easily locate blood donation drives around you.',
  ),
  OnboardingPageData(
    mainTitle:'Track your donation history',
    imagePath: 'assets/images/onboarding_3.png',
    title: 'Your Impact Matters',
    subtitle: 'Track your donation journey and see the impact you make.',
  ),
];