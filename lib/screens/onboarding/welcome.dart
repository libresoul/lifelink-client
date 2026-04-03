import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifelink/widgets/button_with_icon.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          spacing: 20.0,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LIFELINK',
              style: GoogleFonts.syne(
                color: Color(0xFFe71b34),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Be a hero in ',
                style: GoogleFonts.inter(
                  color: Color(0xFF9A8E8F),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: 'minutes',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(text: '\nYour blood saves lives'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: Column(
                spacing: 15.0,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Buttonwithicon(
                          buttonColor: Color(0xFFE71B1E),
                          labelColor: Colors.white,
                          buttonIcon: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                          buttonLabel: 'Donate now',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Buttonwithicon(
                          buttonColor: Color(0xFFF4C9CA),
                          labelColor: Color(0XFF2C2626),
                          buttonLabel: 'I already have an account',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
