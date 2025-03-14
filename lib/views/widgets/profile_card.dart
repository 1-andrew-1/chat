import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/AVA.jpeg', // Replace with actual image URL
            width: SizeConfig.defaultSize * 15 ,
            height: SizeConfig.defaultSize * 15 ,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: SizeConfig.defaultSize * .8,
          right: SizeConfig.defaultSize * .8,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child:  InkWell(
              onTap: () {},
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: SizeConfig.defaultSize * 2.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
