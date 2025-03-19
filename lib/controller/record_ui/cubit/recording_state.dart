part of 'recording_cubit.dart';

abstract class RecordingState {}

class RecordingInitial extends RecordingState {}

class RecordingInProgress extends RecordingState {}

class RecordingStopped extends RecordingState {
  final String? filePath;
  RecordingStopped(this.filePath);
}

class RecordingCancelled extends RecordingState {}
class RecordingError extends RecordingState {
  final String error;
  RecordingError(this.error);
}