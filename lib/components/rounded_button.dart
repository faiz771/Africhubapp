import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  // ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names
  final Color;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    // ignore: non_constant_identifier_names
    required this.Color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color, // Button background color
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, // Text color
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
