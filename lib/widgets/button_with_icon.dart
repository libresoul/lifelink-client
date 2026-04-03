import 'package:flutter/material.dart';

class Buttonwithicon extends StatelessWidget {
  final Color buttonColor;
  final Color labelColor;
  final Icon? buttonIcon;
  final String buttonLabel;
  final VoidCallback onTapped;

  const Buttonwithicon({
    super.key,
    this.buttonColor = Colors.white,
    this.labelColor = Colors.white,
    this.buttonIcon,
    required this.buttonLabel,
    this.onTapped = defaultAction,
  });

  static void defaultAction() {
    // ignore: avoid_print
    print('Button pressed');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTapped,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 14.0)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(buttonColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(buttonLabel, style: TextStyle(color: labelColor, fontSize: 16)),
          SizedBox(width: buttonIcon != null ? 8.0 : 0), // Optional spacing
          ?buttonIcon,
        ],
      ),
    );
  }
}
