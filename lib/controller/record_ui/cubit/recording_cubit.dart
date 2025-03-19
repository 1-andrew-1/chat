import 'package:chatapp/controller/send_message/cubit/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

part 'recording_state.dart';

class RecordingCubit extends Cubit<RecordingState> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final ChatCubit _chatCubit; // Inject ChatCubit

  String? _filePath;

  RecordingCubit(this._chatCubit) : super(RecordingInitial());

  Future<bool> checkPermissions() async {
    if (await Permission.microphone.isGranted) {
      return true; // Already granted
    }

    var micStatus = await Permission.microphone.request();
    if (micStatus.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> toggleRecording({required String receiverID}) async {
    try {
      if (state is RecordingInProgress) {
        // Stop recording
        _filePath = await _audioRecorder.stop();
        if (_filePath != null && _filePath!.isNotEmpty) {
          // 🔹 Upload to Firebase Storage
          String? downloadURL = await uploadAudioToFirebase(_filePath!);
          if (downloadURL != null) {
            // 🔹 Send Firebase URL instead of local path
            _chatCubit.sendMessage(
              message: downloadURL,
              receiverID: receiverID,
              messagetype: 'audio', // Ensure correct type
            );
          }
        }
        emit(RecordingStopped(_filePath ?? ''));
      } else {
        // Check microphone permission
        if (!await checkPermissions()) {
          return;
        }

        // Generate a valid file path
        final directory = await getTemporaryDirectory();
        _filePath =
            '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // Ensure the file path is valid
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _filePath!,
        );

        emit(RecordingInProgress());
      }
    } catch (e) {
      emit(RecordingError(e.toString()));
    }
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.cancel();
    emit(RecordingCancelled());
  }

  Future<String?> uploadAudioToFirebase(String filePath) async {
    try {
      File file = File(filePath);
      String fileName = "audio_${DateTime.now().millisecondsSinceEpoch}.m4a";
      Reference storageRef =
          FirebaseStorage.instance.ref().child("audio_messages/$fileName");

      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _audioRecorder.dispose();
    return super.close();
  }
}
