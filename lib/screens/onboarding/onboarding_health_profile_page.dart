import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/onboarding_draft_store.dart';
import 'package:lifelink/screens/home/app_shell.dart';
import 'package:lifelink/widgets/button_with_icon.dart';

class OnboardingHealthProfilePage extends StatefulWidget {
  final String userId;
  final String? phoneNumber;
  final String? district;

  const OnboardingHealthProfilePage({
    super.key,
    required this.userId,
    required this.phoneNumber,
    required this.district,
  });

  @override
  State<OnboardingHealthProfilePage> createState() =>
      _OnboardingHealthProfilePageState();
}

class _OnboardingHealthProfilePageState
    extends State<OnboardingHealthProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _draftStore = OnboardingDraftStore();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController(text: '60');
  final _api = ApiClient('http://192.168.240.1:8787');

  bool _isSubmitting = false;

  String? _selectedBloodType;
  String? _selectedGender;
  String? _bloodTypeError;
  String? _genderError;

  final List<String> _bloodTypes = const [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  final List<String> _genders = const ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _dobController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime.now(),
    );

    if (selectedDate == null) {
      return;
    }

    final day = selectedDate.day.toString().padLeft(2, '0');
    final month = selectedDate.month.toString().padLeft(2, '0');
    final year = selectedDate.year.toString();
    final formattedDate = '$day/$month/$year';
    setState(() {
      _dobController.text = formattedDate;
    });
  }

  bool _validateSelections() {
    setState(() {
      _bloodTypeError = _selectedBloodType == null
          ? 'Select a blood type'
          : null;
      _genderError = _selectedGender == null ? 'Select a gender' : null;
    });

    return _bloodTypeError == null && _genderError == null;
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final isFormValid = _formKey.currentState!.validate();
    final hasValidSelections = _validateSelections();

    if (!isFormValid || !hasValidSelections) {
      return;
    }

    final rawDob = _dobController.text.trim();
    final dobParts = rawDob.split('/');
    if (dobParts.length != 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid date of birth')));
      return;
    }

    final yyyyMmDd = '${dobParts[2]}-${dobParts[1]}-${dobParts[0]}';

    setState(() {
      _isSubmitting = true;
    });

    try {
      final userId = widget.userId.isNotEmpty
          ? widget.userId
          : await _draftStore.getUserId();
      final phoneNumber =
          widget.phoneNumber ?? await _draftStore.getPhoneNumber();
      final district = widget.district ?? await _draftStore.getDistrict();

      if (userId == null || phoneNumber == null || district == null) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Missing onboarding details. Please try again.'),
          ),
        );
        return;
      }

      await _api.registerDetails(
        userId: userId,
        phoneNumber: phoneNumber,
        district: district,
        bloodType: _selectedBloodType!,
        gender: _selectedGender!,
        dateOfBirth: yyyyMmDd,
        weightKg: double.parse(_weightController.text.trim()),
      );

      await _draftStore.clear();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donor details saved successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppShell()),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildChoiceButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: selected ? const Color(0xFFFFF3F4) : Colors.white,
          side: BorderSide(
            color: selected ? const Color(0xFFE71B34) : const Color(0xFF737171),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? const Color(0xFFE71B34) : const Color(0xFF3D393A),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
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
              'Health Profile',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF514A4B),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Blood Type',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2A2B),
              ),
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < _bloodTypes.length; i += 4) ...[
              Row(
                children: [
                  for (final bloodType in _bloodTypes.sublist(i, i + 4)) ...[
                    _buildChoiceButton(
                      label: bloodType,
                      selected: _selectedBloodType == bloodType,
                      onTap: () {
                        setState(() {
                          _selectedBloodType = bloodType;
                          _bloodTypeError = null;
                        });
                      },
                    ),
                    if (bloodType != _bloodTypes.sublist(i, i + 4).last)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
              if (i < _bloodTypes.length - 4) const SizedBox(height: 8),
            ],
            if (_bloodTypeError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _bloodTypeError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 18),
            Text(
              'Gender',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2A2B),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                for (final gender in _genders) ...[
                  _buildChoiceButton(
                    label: gender,
                    selected: _selectedGender == gender,
                    onTap: () {
                      setState(() {
                        _selectedGender = gender;
                        _genderError = null;
                      });
                    },
                  ),
                  if (gender != _genders.last) const SizedBox(width: 8),
                ],
              ],
            ),
            if (_genderError != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _genderError!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            const SizedBox(height: 18),
            Text(
              'Date of Birth',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2A2B),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _dobController,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: 'dd/mm/yyyy',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              onTap: _pickDate,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Date of birth is required';
                }

                return null;
              },
            ),
            const SizedBox(height: 18),
            Text(
              'Weight (kg)',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2F2A2B),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '60kg',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Weight is required';
                }

                final weight = double.tryParse(value.trim());
                if (weight == null) {
                  return 'Enter a valid weight';
                }

                if (weight < 50) {
                  return 'Minimum 50kg required';
                }

                return null;
              },
            ),
            const SizedBox(height: 6),
            Text(
              'Minimum 50kg required',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF8A8082),
              ),
            ),
            const SizedBox(height: 28),
            Buttonwithicon(
              buttonLabel: _isSubmitting ? 'Saving...' : 'Continue',
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
