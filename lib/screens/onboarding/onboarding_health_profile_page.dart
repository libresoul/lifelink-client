import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/widgets/button_with_icon.dart';

class OnboardingHealthProfilePage extends StatefulWidget {
  const OnboardingHealthProfilePage({super.key});

  @override
  State<OnboardingHealthProfilePage> createState() =>
      _OnboardingHealthProfilePageState();
}

class _OnboardingHealthProfilePageState
    extends State<OnboardingHealthProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  final _weightController = TextEditingController(text: '60');

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

  void _submit() {
    final isFormValid = _formKey.currentState!.validate();
    final hasValidSelections = _validateSelections();

    if (!isFormValid || !hasValidSelections) {
      return;
    }

    debugPrint(
      'Health profile: bloodType=$_selectedBloodType, gender=$_selectedGender, '
      'dob=${_dobController.text}, weight=${_weightController.text}',
    );
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
