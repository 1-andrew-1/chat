import 'dart:async';
import 'dart:io';
import 'package:chatapp/controller/fetching_message/cubit/fetching_message_state.dart';
import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class FetchingMessageCubit extends Cubit<FetchingMessageState> {
  FetchingMessageCubit() : super(FetchingMessageInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<List<FetchMessageModel>>? _messageSubscription;
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;

      final currentPosition = scrollController.position.pixels;
      final maxScroll = scrollController.position.maxScrollExtent;

      if (currentPosition < maxScroll) {
        scrollController.animateTo(
          maxScroll + 50,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutBack,
        );
      }
    });
  }

  void fetchMessages({required String receiverID}) {
    if (isClosed) return; // Prevent execution if the Cubit is closed

    emit(FetchingMessageLoading());

    Stream<List<FetchMessageModel>> messageStream = _firestore
        .collection("users")
        .doc(Constants.userID)
        .collection("Chat")
        .doc(receiverID)
        .collection("Messages")
        .orderBy("date", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return FetchMessageModel.fromJson(doc.id, doc.data());
            }).toList());

    _messageSubscription?.cancel(); // Cancel previous subscription before assigning a new one

    _messageSubscription = messageStream.listen((messages) {
      if (isClosed) return; // Check if Cubit is closed before emitting

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
      if (isClosed) return; // Ensure we don't emit after close
      emit(FetchingMessageError(errorMessage: error.toString()));
    });
  }

  Future<String?> downloadAudioFile(String audioUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(audioUrl);
      final directory = await getTemporaryDirectory();
      final filePath = "${directory.path}/${ref.name}";
      final file = File(filePath);

      if (await file.exists()) {
        return filePath;
      }

      await ref.writeToFile(file);
      return filePath;
    } catch (e) {
      return null;
    }
  }

  void stopListening() {
    _messageSubscription?.cancel();
    _messageSubscription = null;

    if (!isClosed) {
      emit(FetchingMessageInitial()); // Check if Cubit is still active
    }
  }

  Future<void> markMessagesAsRead(String receiverID) async {
    if (isClosed) return; // Prevent execution if the Cubit is closed

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
      await batch.commit();
    }
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel(); // Cancel subscription when closing
    scrollController.dispose(); // Dispose scroll controller
    return super.close();
  }
}
