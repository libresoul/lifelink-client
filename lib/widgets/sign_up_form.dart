import 'package:flutter/material.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/onboarding_draft_store.dart';
import 'package:lifelink/widgets/loading_button.dart';

class SignUpForm extends StatefulWidget {
  final ValueChanged<String> onSubmit;
  const SignUpForm({super.key, required this.onSubmit});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  final _draftStore = OnboardingDraftStore();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _isSubmitting = false;
  late FocusNode pwFocusNode;

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
            keyboardType: TextInputType.emailAddress,
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
            focusNode: pwFocusNode,
            controller: _passwordController,
            obscureText: _isObscured,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: pwFocusNode.hasFocus
                  ? IconButton(
                      onPressed: () => {
                        setState(() {
                          _isObscured = !_isObscured;
                        }),
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                    )
                  : null,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password is Required';
              if (!isValidPassword(value)) {
                return 'Password should contain 8 to 20 characters';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: LoadingButton(
              isLoading: _isSubmitting,
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
    pwFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pwFocusNode = FocusNode();

    pwFocusNode.addListener(() {
      setState(() {});
    });
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
    final passwordRegex = RegExp(r'[\S]{8,20}');
    return passwordRegex.hasMatch(value);
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final api = ApiClient('http://192.168.240.1:8787');
      final userId = await api.register(
        fullname: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _draftStore.saveUserId(userId);
      widget.onSubmit(userId);
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
}
