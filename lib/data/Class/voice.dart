import 'package:just_audio/just_audio.dart';

class PlaybackManager {
  static final PlaybackManager _instance = PlaybackManager._internal();
  AudioPlayer? _currentPlayer;

  factory PlaybackManager() => _instance;

  PlaybackManager._internal();

  Future<void> playNewAudio(AudioPlayer player, String filePath) async {
    // Stop the currently playing audio if it's different
    if (_currentPlayer != null && _currentPlayer != player) {
      await _currentPlayer!.stop();
    }

    _currentPlayer = player;

    // Set new file and play
    await player.setFilePath(filePath);
    await player.play();
  }

  Future<void> stopCurrentAudio() async {
    if (_currentPlayer != null) {
      await _currentPlayer!.stop();
      _currentPlayer = null;
    }
  }
}
