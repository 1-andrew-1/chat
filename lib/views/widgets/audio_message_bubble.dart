import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:chatapp/controller/record_ui_manager/cubit/record_cubit.dart';
import 'package:chatapp/controller/record_ui_manager/cubit/record_state.dart';

class VoiceMessageBubble extends StatelessWidget {
  final bool isSent;
  final DateTime time;
  final String filePath;

  const VoiceMessageBubble({
    super.key,
    required this.isSent,
    required this.time,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceMessageCubit, VoiceMessageState>(
      builder: (context, state) {
        final cubit = context.read<VoiceMessageCubit>();
        return Align(
          alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(10),
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
                      ],
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
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: Row(
              children: [
                GestureDetector(
                  child: cubit.isplaying
                      ? NewWidget(
                          iconData: Icons.pause,
                          onTap: () {
                            cubit.stopAudio();
                          },
                        )
                      : NewWidget(
                          iconData: Icons.play_arrow,
                          onTap: () {
                            cubit.startAudio(filePath);
                          },
                        ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Slider(
                        value: state.progress,
                        onChanged: cubit.seekTo,
                        min: 0.0,
                        max: 1.0,
                        activeColor: Colors.green[700],
                        inactiveColor: Colors.green[100],
                        thumbColor: Colors.green[700],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "0:${(state.position.inSeconds).toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            DateFormat('h:mm a').format(time),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
    required this.iconData,
    required this.onTap,
  });

  final IconData iconData;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.green[700],
        radius: 20,
        child: Icon(
          iconData,
          color: Colors.white,
        ),
      ),
    );
  }
}
