import 'package:flutter/material.dart';
import 'package:lifelink/screens/onboarding/onboarding_screen.dart';
import 'package:lifelink/widgets/button_with_icon.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        spacing: 20.0,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Name is Required';
              if (!isValidName(value)) return 'Enter a valid name';
              return null;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is Required';
              if (!isValidEmail(value)) return 'Enter a valid email';
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password is Required';
              if (!isValidPassword(value)) {
                return 'Password should contain 6 to 20 characters';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Buttonwithicon(
              buttonLabel: 'Continue',
              buttonColor: Color(0xFFe71b1e),
              labelColor: Colors.white,
              onTapped: _submit,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$');
    return emailRegex.hasMatch(value);
  }

  bool isValidName(String value) {
    final nameRegex = RegExp(r"^[\w']+([\s][\w']+)+$");
    return nameRegex.hasMatch(value.trim());
  }

  bool isValidPassword(String value) {
    final passwordRegex = RegExp(r'[\S]{6,20}');
    return passwordRegex.hasMatch(value);
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    }
  }
}
