import 'package:flutter/material.dart';
import 'package:you_app_test/core/gradients/gradient_colors.dart';

class TextGradient extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double size;
  final TextDecoration decoration;

  const TextGradient(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.size,
      required this.decoration});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: GradientColors.goldGradient,
        ).createShader(bounds);
      },
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: size,
            fontWeight: FontWeight.bold,
            // add underline
            decoration: decoration,
            decorationColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
