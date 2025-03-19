import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: SizeConfig.defaultSize * 36,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: Colors.redAccent, // Button color
          borderRadius: BorderRadius.circular(18), // Rounded corners
          boxShadow: const [
             BoxShadow(
              color: Colors.black12, // Soft shadow
              blurRadius: 10,
              offset: Offset(0, 5), // Shadow position
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Logout",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
