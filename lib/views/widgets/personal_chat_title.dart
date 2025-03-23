import 'package:chatapp/controller/fetching_message/cubit/fetching_message_cubit.dart';
import 'package:chatapp/controller/notification/cubit/notification_cubit.dart';
import 'package:chatapp/controller/send_message/cubit/chat_cubit.dart';
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
      required this.UID,
      required this.unreadCount});
  final String title;
  final String subtitle;
  final String UID;
  final int unreadCount;
  @override
  Widget build(BuildContext context) {
    print(subtitle);
    if (unreadCount > 0) {
      context.read<NotificationCubit>().showNotification(
          senderID: Constants.userID,
          body: subtitle,
          title: title,
          payload: UID);
    }
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
      subtitle: SizedBox(
        width: MediaQuery.of(context).size.width - 50, // Adjust as needed
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            children: [
              if (subtitle.contains("https://firebasestorage.googleapis.com"))
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(Icons.mic,
                      size: 16, color: Colors.grey), // Mic icon first
                ),
              if (!subtitle.contains("https://firebasestorage.googleapis.com"))
                TextSpan(text: subtitle) // Show text normally
              else
                const TextSpan(
                    text: " Voice Message"), // Optional text after mic
            ],
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
      trailing: Visibility(
        visible: unreadCount > 0,
        child: CircleAvatar(
          backgroundColor: Colors.blue, // Customize badge color
          radius: unreadCount < 10
              ? 10
              : 12, // Adjust radius based on number length
          child: Text(
            '$unreadCount',
            style: TextStyle(
              fontSize:
                  unreadCount < 10 ? 12 : 10, // Adjust font size dynamically
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () {
        navigateTo(
            context,
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      FetchingMessageCubit()..fetchMessages(receiverID: UID),
                ),
                BlocProvider(
                  create: (context) => ChatCubit()..init(receiverID: UID),
                ),
              ],
              child: ChatScreen(
                title: title,
                receiverID: UID,
                userID: Constants.userID,
              ),
            ));
        // Add navigation or function here
      },
    );
  }
}
