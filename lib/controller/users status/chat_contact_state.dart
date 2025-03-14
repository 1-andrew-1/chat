part of 'chat_contact_cubit.dart';

@immutable
sealed class ChatContactState {}

class ChatContactInitial extends ChatContactState {}

class ChatContactLoading extends ChatContactState {}

class ContactsLoaded extends ChatContactState {
  final List<Contact> contacts;
  ContactsLoaded(this.contacts);
}

class ChatContactLoaded extends ChatContactState {
  final List<Map<String, dynamic>> chatUsers;
  ChatContactLoaded(this.chatUsers);
}

class ChatContactError extends ChatContactState {
  final String message;
  ChatContactError(this.message);
}
