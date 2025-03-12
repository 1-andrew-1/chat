import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/data/message.dart';
import 'package:chatapp/views/widgets/app_bar_chat_screen.dart';
import 'package:chatapp/views/widgets/chat_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.userID, required this.receiverID});
  final String userID , receiverID ;
  Stream<List<MessageModel>> fetchMessages()  {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Constants.userID)
        .collection("Chat")
        .doc(receiverID)
        .collection("Messages")
        .orderBy("date", descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
     print("==============$userID============$receiverID") ;
    return Scaffold(
      appBar: const AppBarChatScreen(),
      body:  Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: fetchMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No messages yet"));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSent = message.senderID == userID;
                    return MessageBubble(
                      text: message.content,
                      isSent: isSent,
                      time: message.date.toString(), // يمكنك تحسين عرض الوقت
                    );
                  },
                );
              },
            ),
          ),
          ChatInputField(receiverID: receiverID,), // شريط إدخال الرسائل
        ],
      ),
    );
  }
}

  
//
// Text Message Bubble
class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSent;
  final String time;

  const MessageBubble(
      {required this.text, required this.isSent, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSent ? Colors.purpleAccent : Colors.grey[700],
          borderRadius: BorderRadius.circular(15),
        ),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                time,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Voice Message Bubble (Static UI)
class VoiceMessageBubble extends StatelessWidget {
  final bool isSent;
  final String time;

  const VoiceMessageBubble({required this.isSent, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSent ? Colors.purpleAccent : Colors.grey[700],
          borderRadius: BorderRadius.circular(15),
        ),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_arrow, color: Colors.white), // Play icon
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white30,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              time,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// Date Separator
class DateSeparator extends StatelessWidget {
  final String date;

  const DateSeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              date,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
