import 'package:chatapp/controller/record_ui_manager/cubit/record_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class VoiceMessageCubit extends Cubit<VoiceMessageState> {
  static VoiceMessageCubit? _currentlyPlayingCubit; // Track the currently playing cubit
  final AudioPlayer _audioPlayer = AudioPlayer();

  VoiceMessageCubit() : super(VoiceMessageState()) {
    _listenToPlayer();
  }

  bool isplaying = false;

  Future<void> startAudio(String filePath) async {
    if (_currentlyPlayingCubit != null && _currentlyPlayingCubit != this) {
      _currentlyPlayingCubit!.stopAudio(); // Stop the currently playing cubit
    }
    isplaying = true;
    _currentlyPlayingCubit = this; // Set the current cubit as the playing one
    try {
      if (state.position > Duration.zero) {
        await _audioPlayer.seek(state.position);
      } else {
        await _audioPlayer.setFilePath(filePath);
      }
      await _audioPlayer.play();
      emit(state.copyWith(isPlaying: false));
    } catch (e) {
      print(e);
    }
  }

  void stopAudio() async {
    if (_currentlyPlayingCubit == this) {
      _currentlyPlayingCubit = null;
    }
    
    isplaying = false;
    final currentPosition = _audioPlayer.position;
    await _audioPlayer.pause();
    emit(state.copyWith(isPlaying: true, position: currentPosition));
  }

  void seekTo(double progress) async {
    final duration = _audioPlayer.duration;
    if (duration != null) {
      final newPosition =
          Duration(milliseconds: (progress * duration.inMilliseconds).toInt());
      await _audioPlayer.seek(newPosition);
      emit(state.copyWith(progress: progress, position: newPosition));
    }
  }

  void _listenToPlayer() {
    _audioPlayer.positionStream.listen((position) async {
      final totalDuration = _audioPlayer.duration;
      if (totalDuration != null && totalDuration.inMilliseconds > 0) {
        emit(state.copyWith(
          progress: position.inMilliseconds / totalDuration.inMilliseconds,
          position: position,
        ));
      }
    });

    _audioPlayer.playerStateStream.listen((playerState) async {
      if (playerState.processingState == ProcessingState.completed) {
        isplaying = false;
        _currentlyPlayingCubit = null; // Reset when finished playing
        await _audioPlayer.stop();
        emit(state.copyWith(
            isPlaying: false, progress: 0.0, position: Duration.zero));
      }
    });
  }
}
