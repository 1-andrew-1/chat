import 'package:chatapp/controller/record_ui/cubit/recording_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({super.key, required this.receiverID});
  final String receiverID;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordingCubit, RecordingState>(
      builder: (context, state) {
        bool isRecording = state is RecordingInProgress;

        return GestureDetector(
          onTap: () {
            // Start recording
            context.read<RecordingCubit>().toggleRecording(receiverID: receiverID);
          },
          onDoubleTap: () {
            // Stop and send the recording
            context.read<RecordingCubit>().toggleRecording(receiverID: receiverID);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRecording ? Colors.red : Colors.grey[300],
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: isRecording ? Colors.white : Colors.black,
            ),
          ),
        );
      },
    );
  }
}
