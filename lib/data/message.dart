import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType { text, image, video, audio, file } // 🔹 Enum for message types

class MessageModel {
  final String content;
  final DateTime date;
  final String senderID;
  final bool isRead;
  final MessageType messageType; // 🔹 Added messageType field

  // Constructor
  MessageModel({
    required this.content,
    required this.date,
    required this.senderID,
    this.isRead = false,
    this.messageType = MessageType.text, // Default to text
  });

  // Factory constructor to create an instance from Firestore Map
  factory MessageModel.fromJson(Map<String, dynamic> data) {
    return MessageModel(
      content: data['content'] ?? '',
      date: (data['date'] != null) ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      senderID: data['senderID'] ?? '',
      isRead: data['isRead'] ?? false,
      messageType: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${data['messageType']}',
        orElse: () => MessageType.text, // Default if not found
      ),
    );
  }

  // Convert instance to JSON (Firestore Map)
  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': Timestamp.fromDate(date),
      'senderID': senderID,
      'isRead': isRead,
      'messageType': messageType.toString().split('.').last, // 🔹 Store as string
    };
  }

  // Empty instance
  factory MessageModel.empty() =>
      MessageModel(content: '', date: DateTime.now(), senderID: '', isRead: false, messageType: MessageType.text);

  @override
  String toString() =>
      'MessageModel(content: $content, date: $date, senderID: $senderID, isRead: $isRead, messageType: $messageType)';
}
class FetchMessageModel {
  final String messageID;
  final String content;
  final DateTime date;
  final String senderID;
  final bool isRead;
  final MessageType messageType;

  FetchMessageModel({
    required this.messageID,
    required this.content,
    required this.date,
    required this.senderID,
    this.isRead = false,
    this.messageType = MessageType.text,
  });

  factory FetchMessageModel.fromJson(String id, Map<String, dynamic> data) {
    return FetchMessageModel(
      messageID: id,
      content: data['content'] ?? '',
      date: (data['date'] != null) ? (data['date'] as Timestamp).toDate() : DateTime.now(),
      senderID: data['senderID'] ?? '',
      isRead: data['isRead'] ?? false,
      messageType: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${data['messageType']}',
        orElse: () => MessageType.text,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageID,
      'content': content,
      'date': Timestamp.fromDate(date),
      'senderID': senderID,
      'isRead': isRead,
      'messageType': messageType.toString().split('.').last,
    };
  }

  @override
  String toString() =>
      'FetchMessageModel(messageID: $messageID, content: $content, date: $date, senderID: $senderID, isRead: $isRead, messageType: $messageType)';
}
