import 'package:chatapp/views/screens/setting/setting.dart';
import 'package:flutter/material.dart';

class ProfileButtonIcon extends StatelessWidget {
  const ProfileButtonIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(
            right: 20,
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ProfileScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/AVA.jpeg'),
            ),
          ),
        );
  }
}