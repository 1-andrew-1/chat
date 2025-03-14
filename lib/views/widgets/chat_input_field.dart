import 'package:chatapp/controller/fetching_message/cubit/fetching_message_cubit.dart';
import 'package:chatapp/controller/send_message/cubit/chat_cubit.dart';
import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key, required this.receiverID});
  final String receiverID;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final Chat = BlocProvider.of<ChatCubit>(context);
    final FocusNode focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 300), () {
          context.read<FetchingMessageCubit>().scrollToBottom();
        });
      }
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
                        hintText: "Message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.defaultSize * 1),
                  InkWell(child: Icon(Icons.mic, color: Colors.grey[600])),
                  SizedBox(width: SizeConfig.defaultSize * 1),
                ],
              ),
            ),
          ),

          SizedBox(width: SizeConfig.defaultSize * 1),

          // Send Button
          InkWell(
            onTap: () {
              if (controller.text.trim().isNotEmpty) {
                // ✅ Prevents empty messages
                Chat.sendMessage(
                    message: controller.text.trim(), receiverID: receiverID);
                controller.clear();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
