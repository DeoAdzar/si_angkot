import 'package:flutter/material.dart';
import 'package:si_angkot/core/utils/app_extension.dart';
import 'package:si_angkot/gen/colors.gen.dart';

// Gradient Button Widget
class CustomGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ).withGradient([MyColors.primaryColor, MyColors.secondaryColor]),
    );
  }
}

// use this widget like this
// GradientButton(text: "Login", onPressed: () => print("Button Pressed")),
