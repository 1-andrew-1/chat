import 'package:flutter/material.dart';

class CustomProfileButton extends StatelessWidget {
  const CustomProfileButton({super.key, required this.textname ,required this.iconData, required this.callback});
  final String textname ;
  final VoidCallback callback;
  final IconData iconData ;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: [
            const SizedBox(width: 15,) ,
            Icon(iconData, size: 24), // Key icon
            const SizedBox(width: 20), // Space between icon and text
            Text(
              textname,
              style: const TextStyle(
                fontSize: 16,
                //color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
