import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String? buttonText; // Bisa null jika ada widget custom
  final double width;
  final bool isClicked;
  final VoidCallback? onpressed;
  final Widget? child; // Widget custom, seperti CircularProgressIndicator

  const RoundedButtonWidget({
    super.key,
    this.buttonText,
    required this.width,
    required this.isClicked,
    required this.onpressed,
    this.child,
  });

  Color darkenColor(Color color, double amount) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0), // Kurangi lightness
    );

    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 5.0,
          ),
        ],
        gradient: isClicked == true
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 1.0],
                colors: [
                  Color(0xFF62CDCB),
                  Color(0xFF4599DB),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 1.0],
                colors: [
                  darkenColor(const Color(0xFF62CDCB), 0.3),
                  darkenColor(const Color(0xFF4599DB), 0.3),
                ],
              ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          minimumSize: WidgetStateProperty.all(Size(width, 50)),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: onpressed,
        child: child ??
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                buttonText ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: isClicked == true
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      ),
    );
  }
}
