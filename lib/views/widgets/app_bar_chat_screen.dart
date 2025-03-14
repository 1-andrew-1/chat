import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';

class AppBarChatScreen extends StatelessWidget implements PreferredSizeWidget {
  const AppBarChatScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title:  Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/AVA.jpeg'), // Replace with real image URL
            radius: 18,
          ),
          SizedBox(width: SizeConfig.defaultSize * .5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "John Doe",
                style: TextStyle(
                  //color: Colors.white,
                  fontSize: SizeConfig.defaultSize * 2 ,//18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Online",
                style: TextStyle(
                  color: Colors.purple,
                  fontSize: SizeConfig.defaultSize * 1.2 , // 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}