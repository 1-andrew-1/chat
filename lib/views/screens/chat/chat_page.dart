import 'package:chatapp/controller/fetching_message/cubit/fetching_message_cubit.dart';
import 'package:chatapp/controller/fetching_message/cubit/fetching_message_state.dart';
import 'package:chatapp/views/widgets/chat_bubble_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/views/widgets/app_bar_chat_screen.dart';
import 'package:chatapp/views/widgets/chat_input_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key, required this.userID, required this.receiverID});

  final String userID, receiverID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FetchingMessageCubit()..fetchMessages(receiverID: receiverID),
      child: Scaffold(
        appBar: const AppBarChatScreen(),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<FetchingMessageCubit, FetchingMessageState>(
                builder: (context, state) {
                  if (state is FetchingMessageLoading) {
                    try {
                      context
                          .read<FetchingMessageCubit>()
                          .markMessagesAsRead(receiverID);
                    } catch (e) {
                      debugPrint("Error marking messages as read: $e");
                    }
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is FetchingMessageLoaded) {
                    context
                          .read<FetchingMessageCubit>().scrollToBottom();
                    final messages = state.messages;
                    // Safely mark messages as read
                    if (messages.isEmpty) {
                      return const Center(child: Text("No messages yet"));
                    }
                    return ListView.builder(
                      controller: context
                          .read<FetchingMessageCubit>().scrollController,
                      padding: const EdgeInsets.all(10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isSent = message.senderID == userID;
                        return MessageBubble(
                          text: message.content,
                          isSent: isSent,
                          time: message.date, // Format time properly
                        );
                      },
                    );
                  } else if (state is FetchingMessageError) {
                    return Center(child: Text("Error: ${state.errorMessage}"));
                  }
                  return const Center(child: Text("Start a conversation"));
                },
              ),
            ),
            ChatInputField(receiverID: receiverID),
          ],
        ),
      ),
    );
  }
}

//
// Text Message Bubble

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
