import 'dart:async';
import 'package:chatapp/controller/fetching_message/cubit/fetching_message_state.dart';
import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchingMessageCubit extends Cubit<FetchingMessageState> {
  FetchingMessageCubit() : super(FetchingMessageInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<List<MessageModel>>? _messageSubscription;
  final ScrollController scrollController = ScrollController();
  
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 50,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
        );
      }
    });
  }

  void fetchMessages({required String receiverID}) {
    emit(FetchingMessageLoading());

    Stream<List<MessageModel>> messageStream = _firestore
        .collection("users")
        .doc(Constants.userID)
        .collection("Chat")
        .doc(receiverID)
        .collection("Messages")
        .orderBy("date", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList());

    // Cancel previous subscription if active
    _messageSubscription?.cancel();

    _messageSubscription = messageStream.listen((messages) {
      if (messages.isNotEmpty) {
        final unreadCount = messages.where((msg) => !msg.isRead).length;
        final lastMessage = messages.last.content;

        emit(FetchingMessageLoaded(
          messages: messages,
          unreadCount: unreadCount,
          lastMessage: lastMessage,
        ));
      } else {
        emit(FetchingMessageLoaded(
          messages: const [],
          unreadCount: 0,
          lastMessage: '',
        ));
      }
    }, onError: (error) {
      emit(FetchingMessageError(errorMessage: error.toString()));
    });
  }

  /// Stops listening to the stream when the user leaves the chat
  void stopListening() {
    _messageSubscription?.cancel();
    _messageSubscription = null;
    emit(FetchingMessageInitial());
  }

  /// Marks all messages as read using batch processing for efficiency
  Future<void> markMessagesAsRead(String receiverID) async {
    final messagesRef = _firestore
        .collection("users")
        .doc(Constants.userID)
        .collection("Chat")
        .doc(receiverID)
        .collection("Messages");

    var unreadMessages =
        await messagesRef.where("isRead", isEqualTo: false).get();

    if (unreadMessages.docs.isNotEmpty) {
      WriteBatch batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {"isRead": true});
      }
      await batch.commit(); // Perform batch update
    }
  }
}
