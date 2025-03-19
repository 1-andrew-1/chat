import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Navigator.of(context).push(
            //     PageRouteBuilder(
            //       pageBuilder: (context, animation, secondaryAnimation) =>
            //           const ChatScreen(recievedUid:'andrew' ,),
            //       transitionsBuilder:
            //           (context, animation, secondaryAnimation, child) {
            //         return FadeTransition(
            //           opacity: animation,
            //           child: child,
            //         );
            //       },
            //     ),
            //   );
          },
          child: const ListTile(
            leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/AVA.jpeg'),
                ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.push_pin, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Craig', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('10:30 AM', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            subtitle: Text('This is a sample message',
                style: TextStyle(color: Colors.grey)),
          ),
        ),
        const Divider(thickness: 1, indent: 16, endIndent: 16 , height: .4,), // Separator Line
      ],
    );
  }
}
