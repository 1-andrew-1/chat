import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/data/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

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
  Future<void> sendMessage(
      {required String message, required String receiverID}) async {
    MessageModel messageModel = MessageModel(
        content: message,
        date: DateTime.now() ,
        senderID: Constants.userID,
        isRead: false);

    Map<String, dynamic> messageMap = messageModel.toJson();

    // حفظ الرسالة محليًا في القائمة
    localMessages.add(messageMap);

    // إرسال البيانات إلى Firestore (للمرسل)
    if ( receiverID != Constants.userID ) {
      DocumentReference chatRef = fire
          .collection("users")
          .doc(receiverID)
          .collection("Chat")
          .doc(Constants.userID);

      // Ensure Chat document exists before adding a message
      await chatRef.set({"exists": true}, SetOptions(merge: true));
      messageMap['isRead'] = false ;
      // Add message to Messages collection
      await chatRef.collection("Messages").add(messageMap);
    }
    // إرسال البيانات إلى Firestore (للمستقبل)

    DocumentReference chatRef = fire
        .collection("users")
        .doc(Constants.userID)
        .collection("Chat")
        .doc(receiverID);
    // Ensure Chat document exists before adding a message
    await chatRef.set({"exists": true}, SetOptions(merge: true));
    messageMap['isRead'] = true ;
    // Add message to Messages collection
    await chatRef.collection("Messages").add(messageMap);
    debugPrint("✅ Message Sent Successfully");
    debugPrint("Message Sent Successfully");

    emit(SendMessageSuccessState());
  }
}
