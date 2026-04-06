import 'package:flutter/material.dart';

class DonationGuideScreen extends StatelessWidget {
  const DonationGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get Ready to Donate',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Everything you need to know',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Eligibility Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1F1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFE0E0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDADA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.access_time, color: Color(0xFFD32F2F)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Your next eligible date',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'July 01, 2026',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const SectionTitle(title: 'Before Donation'),

            const DonationStepCard(
              title: 'Stay Hydrated',
              subtitle: 'Drink at least 16 oz (500ml) of water before your appointment.',
              icon: Icons.water_drop_outlined,
              iconColor: Colors.blue,
              iconBg: Color(0xFFE3F2FD),
            ),
            const DonationStepCard(
              title: 'Eat a Healthy Meal',
              subtitle: 'Have a nutritious, iron-rich meal 2-3 hours before donating.',
              icon: Icons.apple_outlined,
              iconColor: Colors.green,
              iconBg: Color(0xFFE8F5E9),
            ),
            const DonationStepCard(
              title: 'Get Enough Sleep',
              subtitle: 'Ensure you get at least 7-8 hours of sleep the night before.',
              icon: Icons.bed_outlined,
              iconColor: Colors.indigo,
              iconBg: Color(0xFFE8EAF6),
            ),
            const DonationStepCard(
              title: 'Avoid Caffeine & Alcohol',
              subtitle: 'Skip coffee and alcohol for at least 24 hours before donation.',
              icon: Icons.coffee_outlined,
              iconColor: Colors.orange,
              iconBg: Color(0xFFFFF3E0),
            ),
            const DonationStepCard(
              title: 'Avoid Heavy Exercise',
              subtitle: 'No strenuous workouts on the day of donation.',
              icon: Icons.fitness_center,
              iconColor: Colors.pink,
              iconBg: Color(0xFFFCE4EC),
            ),
            const DonationStepCard(
              title: 'Review Your Medications',
              subtitle: 'Inform the staff about any medications you are currently taking.',
              icon: Icons.medication_outlined,
              iconColor: Colors.purple,
              iconBg: Color(0xFFF3E5F5),
            ),

            const SizedBox(height: 24),
            const SectionTitle(title: 'Day-of Checklist'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: const [
                  ChecklistItem(text: 'Bring a valid photo ID'),
                  ChecklistItem(text: 'Wear comfortable clothing with loose sleeves'),
                  ChecklistItem(text: 'Eat a light snack if needed'),
                  ChecklistItem(text: 'Arrive 10 minutes early to fill paperwork'),
                  ChecklistItem(text: 'Relax and stay calm — you\'re saving lives!'),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const SectionTitle(title: 'After Donation'),
            const SimpleInfoCard(
              title: 'Rest for 15 minutes',
              subtitle: 'Stay at the donation site and have a snack or juice.',
            ),
            const SimpleInfoCard(
              title: 'Keep the bandage on',
              subtitle: 'Leave it on for at least 4 hours to avoid bruising.',
            ),
            const SimpleInfoCard(
              title: 'Drink extra fluids',
              subtitle: 'Replenish with water and juice for the next 24-48 hours.',
            ),
            const SimpleInfoCard(
              title: 'Avoid heavy lifting',
              subtitle: 'No strenuous activity for at least 6 hours after donating.',
            ),
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // "Donate" is active
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.star_outline), label: 'Donate'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
      ),
    );
  }
}

class DonationStepCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;

  const DonationStepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChecklistItem extends StatelessWidget {
  final String text;
  const ChecklistItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFFD32F2F), size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

class SimpleInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const SimpleInfoCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }
}