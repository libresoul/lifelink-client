import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/widgets/button_with_icon.dart';

class OnboardingContactDetailsPage extends StatefulWidget {
  final VoidCallback onContinue;

  const OnboardingContactDetailsPage({super.key, required this.onContinue});

  @override
  State<OnboardingContactDetailsPage> createState() =>
      _OnboardingContactDetailsPageState();
}

class _OnboardingContactDetailsPageState
    extends State<OnboardingContactDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: '+94');

  final List<String> _districts = const [
    'Colombo',
    'Gampaha',
    'Kandy',
    'Galle',
    'Kurunegala',
    'Jaffna',
  ];

  String _selectedDistrict = 'Colombo';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _isValidPhone(String value) {
    final phoneRegex = RegExp(r'^\+?[0-9]{9,12}$');
    return phoneRegex.hasMatch(value.trim());
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onContinue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tell us more about yourself',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF514A4B),
              ),
            ),
            const SizedBox(height: 28),
            Image.asset('assets/images/onboarding_3.png', height: 180),
            const SizedBox(height: 28),
            Text(
              'Phone Number',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2A2B),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Phone number is required';
                }

                if (!_isValidPhone(value)) {
                  return 'Enter a valid phone number';
                }

                return null;
              },
            ),
            const SizedBox(height: 18),
            Text(
              'District',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2A2B),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedDistrict,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: _districts
                  .map(
                    (district) => DropdownMenuItem<String>(
                      value: district,
                      child: Text(district),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                setState(() => _selectedDistrict = value);
              },
            ),
            const SizedBox(height: 32),
            Buttonwithicon(
              buttonLabel: 'Continue',
              buttonColor: const Color(0xFFE71B1E),
              labelColor: Colors.white,
              onTapped: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
