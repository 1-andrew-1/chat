import 'package:chatapp/controller/chat/cubit/chat_cubit.dart';
import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/views/screens/chat/chat_page.dart';
import 'package:chatapp/views/widgets/custom_page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class PersonalChatTitle extends StatelessWidget {
  const PersonalChatTitle(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.UID});
  final String title;
  final String subtitle;
  final String UID;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        radius: 24,
        backgroundImage:
            AssetImage('assets/images/AVA.jpeg'), // Replace with your image
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      onTap: () {
        print(
            "=====================================================================$UID");
        navigateTo(context,BlocProvider(
          create: (context) => ChatCubit()..init(receiverID: UID),
          child: 
           ChatScreen(receiverID: UID , userID: Constants.userID,),
        ));
        // Add navigation or function here
      },
    );
  }
}
