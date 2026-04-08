import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/session_store.dart';
import 'package:lifelink/screens/auth/login.dart';
import 'package:lifelink/screens/onboarding/onboarding_screen.dart';
import 'package:lifelink/widgets/button_with_icon.dart';
import 'package:lifelink/widgets/sign_up_form.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _api = ApiClient('http://192.168.240.1:8787');
  final _sessionStore = SessionStore();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.08,
            vertical: height * 0.04,
          ),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Join with ',
                      style: GoogleFonts.inter(
                        color: Color(0xFF534D4E),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'LIFELINK',
                          style: GoogleFonts.syne(
                            color: Color(0xFFE71B34),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40.0, 0.0, 20.0),
                  child: SignUpForm(onSubmit: _onSubmit),
                ),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Buttonwithicon(
                    buttonIcon: SvgPicture.asset(
                      'assets/icons/google.svg',
                      height: 24,
                      width: 24,
                    ),
                    buttonColor: Color(0XFFFFF8F8),
                    labelColor: Colors.black,
                    iconDirection: IconDirection.left,
                    buttonLabel: 'Continue with Google',
                    buttonStyles: ButtonStyle(
                      side: WidgetStatePropertyAll(BorderSide(width: 1.0)),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: GoogleFonts.inter(
                      color: Color(0xFF41393A),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Log In',
                            style: GoogleFonts.inter(
                              color: Color(0xFFE71B34),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSubmit(String userId, String email, String password) async {
    try {
      final loginResponse = await _api.login(email: email, password: password);
      await _sessionStore.save(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        userId: loginResponse.userId,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Signed up, but automatic login failed. Please log in.',
          ),
        ),
      );
    }

    if (!mounted) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen(userId: userId)),
    );
  }
}
