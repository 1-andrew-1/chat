import 'package:chatapp/controller/chat/cubit/chat_cubit.dart';
import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key, required this.receiverID});
  final String receiverID;
  @override
  Widget build(BuildContext context) {
    final  TextEditingController controller = TextEditingController();
    final Chat = BlocProvider.of<ChatCubit>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          // Text Field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius:
                  BorderRadius.circular(12), // Rectangle with rounded corners
              ),
              child: Row(
                children: [
                  SizedBox(width: SizeConfig.defaultSize * 1),  // 10
                  // for selected photos or videos or any files
                  Icon(Icons.attach_file,
                      color: Colors.grey[600]), // Attachment Icon
                  const SizedBox(width: 10),
                   Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: TextInputType.text, // Keyboard type for text input
                      decoration: const InputDecoration(
                        hintText: "Message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // for send records 
                  InkWell(child: Icon(Icons.mic, color: Colors.grey[600])), // Mic Icon
                  SizedBox(width: SizeConfig.defaultSize * 1),
                ],
              ),
            ),
          ),

          SizedBox(width: SizeConfig.defaultSize * 1),

          // Send Button 
          InkWell(
            onTap: () {
              print("================${controller.text}") ;
              Chat.sendMessage(message: controller.text, receiverID: receiverID);
              controller.clear();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.purpleAccent,
                borderRadius:
                    BorderRadius.circular(12), // Rectangle with rounded corners
              ),
              padding: const EdgeInsets.all(12), // Adjust padding for better size
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
