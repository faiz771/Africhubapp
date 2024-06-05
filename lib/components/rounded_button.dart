import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color;

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
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
            style: TextStyle(
                color: Colors.white, // Text color
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
