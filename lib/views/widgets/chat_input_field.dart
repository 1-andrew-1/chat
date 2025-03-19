import 'package:chatapp/controller/fetching_message/cubit/fetching_message_cubit.dart';
import 'package:chatapp/controller/record_ui/cubit/recording_cubit.dart';
import 'package:chatapp/controller/send_message/cubit/chat_cubit.dart';
import 'package:chatapp/views/widgets/recourd_button.dart';
import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key, required this.receiverID});
  final String receiverID;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();
    final ValueNotifier<bool> isFocused = ValueNotifier(false);
    final ValueNotifier<bool> isTyping = ValueNotifier(false);

    focusNode.addListener(() {
      isFocused.value = focusNode.hasFocus;
      if (focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (context.mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.read<FetchingMessageCubit>().scrollToBottom();
              }
            });
          }
        });
      }
    });

    controller.addListener(() {
      isTyping.value = controller.text.trim().isNotEmpty;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // Text Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(width: SizeConfig.defaultSize * 1),
                  Icon(Icons.attach_file, color: Colors.grey[600]),
                  SizedBox(width: SizeConfig.defaultSize * 1),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: SizeConfig.defaultSize * 1),
          // Mic / Send Button
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: isTyping,
              builder: (context, typing, child) {
                if (typing) {
                  // Show Send Button
                  return GestureDetector(
                    onTap: () {
                      if (controller.text.trim().isNotEmpty) {
                        context.read<ChatCubit>().sendMessage(
                              message: controller.text.trim(),
                              receiverID: receiverID,
                              messagetype: 'text',
                            );
                        controller.clear();
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    ),
                  );
                } else {
                  // Show Mic Button with Different Action
                  return BlocProvider(
                    create: (context) =>
                        RecordingCubit(context.read<ChatCubit>()),
                    child: RecordButton(
                      receiverID: receiverID,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
