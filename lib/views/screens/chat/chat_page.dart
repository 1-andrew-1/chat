import 'package:chatapp/controller/fetching_message/cubit/fetching_message_cubit.dart';
import 'package:chatapp/controller/fetching_message/cubit/fetching_message_state.dart';
import 'package:chatapp/controller/notification/cubit/notification_cubit.dart';
import 'package:chatapp/controller/record_ui_manager/cubit/record_cubit.dart';
import 'package:chatapp/data/message.dart';
import 'package:chatapp/views/widgets/chat_bubble_message.dart';
import 'package:chatapp/views/widgets/audio_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/views/widgets/app_bar_chat_screen.dart';
import 'package:chatapp/views/widgets/chat_input_field.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(
      {super.key,
      required this.userID,
      required this.receiverID,
      required this.title});

  final String userID, receiverID, title;
  @override
  Widget build(BuildContext context) {
    context.read<NotificationCubit>().setCurrentChatUser(userID); 
    return PopScope(
      canPop: true, // Allow back navigation
      onPopInvoked: (didPop) {
        if (didPop) {
          // Reset the current chat user when leaving
          BlocProvider.of<NotificationCubit>(context).setCurrentChatUser(null);
        }
      },
      child: Scaffold(
        appBar: AppBarChatScreen(
          name: title,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<FetchingMessageCubit, FetchingMessageState>(
                builder: (context, state) {
                  if (state is FetchingMessageLoaded) {
                    final messages = state.messages;
                    context.read<FetchingMessageCubit>().markMessagesAsRead(receiverID);
                    context.read<FetchingMessageCubit>().scrollToBottom();
                    if (messages.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) {
                          context.read<FetchingMessageCubit>().scrollToBottom();
                        }
                      });
                    }
      
                    return ListView.builder(
                      controller:
                          context.read<FetchingMessageCubit>().scrollController,
                      padding: const EdgeInsets.all(10),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isSent = message.senderID == userID;
      
                        if (message.messageType == MessageType.audio) {
                          return FutureBuilder<String?>(
                            future: context
                                .read<FetchingMessageCubit>()
                                .downloadAudioFile(message.content),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasData &&
                                  snapshot.data != null) {
                                return BlocProvider(
                                  create: (context) => VoiceMessageCubit(),
                                  child: VoiceMessageBubble(
                                    filePath: snapshot.data!,
                                    isSent: isSent,
                                    time: message.date,
                                  ),
                                );
                              } else {
                                return const Text("Audio unavailable");
                              }
                            },
                          );
                        }
                        return MessageBubble(
                          receivedid : receiverID ,
                          text: message.content,
                          isSent: isSent,
                          time: message.date, 
                          messageid: message.messageID, 
                          senderid: message.senderID,
                        );
                      },
                    );
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

// Date Separator
class DateSeparator extends StatelessWidget {
  final String date;

  const DateSeparator({super.key, required this.date});

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
