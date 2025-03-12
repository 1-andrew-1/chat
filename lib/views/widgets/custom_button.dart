import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  const CustomButtonAuth({
    super.key,
    required this.onPressed, required this.childWidget,
  });
  final VoidCallback onPressed;
  final Widget childWidget;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF5ECFF), // Light purple, // Softer modern color
          foregroundColor: const Color(0xFF512DA8), // Text color
          //elevation: 4, // Adds depth
          //shadowColor: Colors.black.withOpacity(0.2), // Softer shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Slightly more rounded
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 14, horizontal: 24), // Better spacing
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: onPressed, // ✅ Fixed: Now it executes the function
        child: childWidget ,
      ),
    );
  }
}
