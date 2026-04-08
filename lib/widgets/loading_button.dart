import 'package:flutter/material.dart';
import 'package:lifelink/widgets/button_with_icon.dart';

class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTapped;
  final Color buttonColor;
  final Color labelColor;
  final String buttonLabel;
  final ButtonStyle? buttonStyles;
  final Widget? buttonIcon;
  final IconDirection iconDirection;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onTapped,
    required this.buttonColor,
    required this.labelColor,
    required this.buttonLabel,
    this.buttonStyles,
    this.buttonIcon,
    this.iconDirection = IconDirection.right,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: isLoading ? null : onTapped,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16.0)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(buttonColor),
        ).merge(buttonStyles),
        child: isLoading
            ? SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(labelColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (buttonIcon != null &&
                      iconDirection == IconDirection.left) ...[
                    buttonIcon!,
                    SizedBox(width: 8.0),
                  ],
                  Text(
                    buttonLabel,
                    style: TextStyle(color: labelColor, fontSize: 16),
                  ),
                  if (buttonIcon != null &&
                      iconDirection == IconDirection.right) ...[
                    SizedBox(width: 8.0),
                    buttonIcon!,
                  ],
                ],
              ),
      ),
    );
  }
}
