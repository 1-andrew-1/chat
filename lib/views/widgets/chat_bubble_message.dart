import 'package:chatapp/controller/delete_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isSent;
  final DateTime time;
  final String messageid ;
  final String senderid ;
  final String receivedid ;
  const MessageBubble({
    super.key,
    required this.text,
    required this.isSent,
    required this.time, required this.messageid, required this.senderid, required this.receivedid,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(time); // Format time
    return InkWell(
      onLongPress: () {
        context.read<DeleteMessageCubit>().showDeleteOptions(context,receivedid,senderid,messageid);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSent ? Colors.blueAccent : Colors.grey[800],
              gradient: isSent
                  ? const LinearGradient(
                      colors: [Color(0xFF62B6CB), Color(0xFF1B4965)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    )
                  : const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 54, 49, 49),
                        Color(0xFFBDBDBD),
                      ], // Soft gray gradient for received messages
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                topRight: const Radius.circular(15),
                bottomLeft: isSent ? const Radius.circular(15) : Radius.zero,
                bottomRight: isSent ? Radius.zero : const Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(2, 3),
                )
              ],
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
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
                    formattedTime,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// ✅ دالة مستقلة لعرض الحوار التأكيدي
