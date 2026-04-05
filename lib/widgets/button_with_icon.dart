import 'package:flutter/material.dart';

enum IconDirection { left, right }

class Buttonwithicon extends StatelessWidget {
  final Color buttonColor;
  final Color labelColor;
  final Widget? buttonIcon;
  final IconDirection iconDirection;
  final String buttonLabel;
  final ButtonStyle? buttonStyles;
  final VoidCallback onTapped;

  const Buttonwithicon({
    super.key,
    required this.buttonColor,
    required this.labelColor,
    this.buttonIcon,
    this.iconDirection = IconDirection.right,
    required this.buttonLabel,
    this.buttonStyles,
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
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16.0)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(buttonColor),
      ).merge(buttonStyles),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (buttonIcon != null && iconDirection == IconDirection.left) ...[
            buttonIcon!,
            SizedBox(width: 8.0),
          ],
          Text(buttonLabel, style: TextStyle(color: labelColor, fontSize: 16)),
          if (buttonIcon != null && iconDirection == IconDirection.right) ...[
            SizedBox(width: 8.0),
            buttonIcon!,
          ],
        ],
      ),
    );
  }
}
