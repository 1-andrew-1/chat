part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {
  
}
final class SendMessageSuccessState extends ChatInitial {}
class SendMessageLoadingState extends ChatState {}
class SendMessageErrorState extends ChatState {
  final String error;
  SendMessageErrorState(this.error);
}
class ChatMessagesLoaded extends ChatState {
  final List<MessageModel> messages;
  ChatMessagesLoaded(this.messages);
}

class ChatInitializedState extends ChatState {}