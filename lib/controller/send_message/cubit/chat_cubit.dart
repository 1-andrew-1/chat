import 'dart:io';

import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:record/record.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  final record = AudioRecorder();

  final FirebaseFirestore fire = FirebaseFirestore.instance;
  late SharedPreferences pref;
  String? userID;
  String? receiverID;
  List<Map<String, dynamic>> localMessages = []; // قائمة لحفظ الرسائل مؤقتًا

  Future<void> init({required String receiverID}) async {
    this.receiverID = receiverID; // حفظ معرف المستقبل
    pref = await SharedPreferences.getInstance();
    userID = Constants.userID;
    if (userID == null) {
      debugPrint(
          "Error: User ID is null. Ensure it's set before initializing.");
      return;
    }

    debugPrint("User ID Loaded: $userID");
    debugPrint("Receiver ID Loaded: $receiverID");

    emit(ChatInitial());
  }

  /// إرسال رسالة
  // Function to detect message type
  MessageType detectMessageType(String message) {
    if (message
        .contains(RegExp(r'\.(jpg|jpeg|png|gif)$', caseSensitive: false))) {
      return MessageType.image;
    } else if (message
        .contains(RegExp(r'\.(mp4|mov|avi)$', caseSensitive: false))) {
      return MessageType.video;
    } else if (message
        .contains(RegExp(r'\.(mp3|wav|ogg)$', caseSensitive: false))) {
      return MessageType.audio;
    } else {
      return MessageType.text;
    }
  }
  MessageType detectType(String message) {
    if ( message == 'audio' ) {
      return MessageType.audio;
    } else {
      return MessageType.text;
    }
  }
// Function to upload a voice message
  Future<String> uploadVoiceMessage(String filePath) async {
    String fileName =
        "voice_${DateTime.now().millisecondsSinceEpoch}.mp3"; // Unique name
    Reference storageRef =
        FirebaseStorage.instance.ref().child("voice_messages/$fileName");

    UploadTask uploadTask = storageRef.putFile(File(filePath));
    TaskSnapshot taskSnapshot = await uploadTask;

    return await taskSnapshot.ref.getDownloadURL(); // Return URL after upload
  }

// Send message function
  Future<void> sendMessage({
    required String message,
    required String receiverID,
    String? voiceFilePath, // Optional for voice messages
    required String messagetype,
  }) async {
    DateTime now = DateTime.now();

    String messageContent = message;
    MessageType messageType = detectType(messagetype);

    // If it's a voice message, upload the file first
    if (voiceFilePath != null) {
      messageContent = await uploadVoiceMessage(voiceFilePath);
      messageType = MessageType.audio;
    }

    // Create message model
    MessageModel messageModel = MessageModel(
      content: messageContent,
      date: now,
      senderID: Constants.userID,
      isRead: false,
      messageType: messageType,
    );

    // Convert to JSON
    Map<String, dynamic> senderMessageMap = messageModel.toJson();
    Map<String, dynamic> receiverMessageMap = {
      ...senderMessageMap,
      'isRead': false
    };

    // Save message locally
    localMessages.add(senderMessageMap);

    DocumentReference senderChatRef = fire
        .collection("users")
        .doc(Constants.userID)
        .collection("Chat")
        .doc(receiverID);
    await senderChatRef.set({"exists": true}, SetOptions(merge: true));
    await senderChatRef
        .collection("Messages")
        .add({...senderMessageMap, 'isRead': true}); // Sender sees as read
    if (Constants.userID != receiverID) {
      DocumentReference receiverChatRef = fire
          .collection("users")
          .doc(receiverID)
          .collection("Chat")
          .doc(Constants.userID);
      await receiverChatRef.set({"exists": true}, SetOptions(merge: true));
      await receiverChatRef
          .collection("Messages")
          .add(receiverMessageMap); // Receiver sees as unread
    }
    debugPrint("✅ Message Sent Successfully (Type: $messageType)");

    emit(SendMessageSuccessState());
  }
}
