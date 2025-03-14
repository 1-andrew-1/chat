import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String content;
  final DateTime date;
  final String senderID;
  final bool isRead; // 🔹 Added isRead field

  // Constructor
  MessageModel({
    required this.content,
    required this.date,
    required this.senderID,
    this.isRead = false, // Default to false (unread)
  });

  // Factory constructor to create an instance from Firestore Map
  factory MessageModel.fromJson(Map<String, dynamic> data) {
    return MessageModel(
      content: data['content'] ?? '',
      date: (data['date'] != null) ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      senderID: data['senderID'] ?? '',
      isRead: data['isRead'] ?? false, // Load isRead from Firestore
    );
  }

  // Convert instance to JSON (Firestore Map)
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': Timestamp.fromDate(date),
      'senderID': senderID,
      'isRead': isRead, // 🔹 Include isRead in Firestore
    };
  }

  // Empty instance
  factory MessageModel.empty() =>
      MessageModel(content: '', date: DateTime.now(), senderID: '', isRead: false);

  @override
  String toString() =>
      'MessageModel(content: $content, date: $date, senderID: $senderID, isRead: $isRead)';
}
