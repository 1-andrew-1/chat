class VoiceMessageState {
  final bool isPlaying;
  final double progress;
  final Duration position;

  VoiceMessageState({
    this.isPlaying = false,
    this.progress = 0.0,
    this.position = Duration.zero,
  });

  VoiceMessageState copyWith({bool? isPlaying, double? progress, Duration? position}) {
    return VoiceMessageState(
      isPlaying: isPlaying ?? this.isPlaying,
      progress: progress ?? this.progress,
      position: position ?? this.position,
    );
  }
}