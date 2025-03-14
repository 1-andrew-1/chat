import 'package:chatapp/core/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'chat_contact_state.dart';

class ChatContactCubit extends Cubit<ChatContactState> {
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  List<Contact> contacts = [];

  ChatContactCubit() : super(ChatContactInitial()) {
    _initializeContacts();
  }

  /// Initializes the contact list and fetches matched chat contacts
  Future<void> _initializeContacts() async {
    bool permissionGranted = await FlutterContacts.requestPermission();
    if (permissionGranted) {
      await loadContactsFromDevice();
      await fetchMatchedChatContacts();
    } else {
      emit(ChatContactError("Permission denied to access contacts."));
    }
  }

  /// Fetch receiver UIDs from Firestore
  Future<List<String>> getChatReceiverUIDs() async {
    try {
      var snapshot = await fire
          .collection("users")
          .doc(Constants.userID)
          .collection("Chat")
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      return [];
    }
  }

  /// Load contacts from the device
  Future<void> loadContactsFromDevice() async {
    try {
      contacts = await FlutterContacts.getContacts(withProperties: true);
      emit(ContactsLoaded(contacts));
    } catch (e) {
      emit(ChatContactError("Failed to load contacts: $e"));
    }
  }

  /// Fetch and match contacts with Firebase users, including last message
  Future<void> fetchMatchedChatContacts() async {
    if (contacts.isEmpty) return;

    emit(ChatContactLoading());

    try {
      List<String> receiverUIDs = await getChatReceiverUIDs();
      if (receiverUIDs.isEmpty) {
        emit(ChatContactLoaded(const []));
        return;
      }

      List<Map<String, dynamic>> chatUsers = [];

      for (String uid in receiverUIDs) {
        DocumentSnapshot userDoc =
            await fire.collection("users").doc(uid).get();
        if (!userDoc.exists) continue;

        Map<String, dynamic> userData =
            userDoc.data() as Map<String, dynamic>? ?? {};
        String phoneNumber = userData["phoneNumber"] ?? "";

        // البحث عن الاسم المطابق في جهات الاتصال
        Contact? matchedContact = contacts.firstWhere(
          (contact) => contact.phones.any(
            (phone) => phone.number.replaceAll(" ", "").contains(phoneNumber),
          ),
          orElse: () => Contact(),
        );

        String displayName = matchedContact.displayName.isNotEmpty
            ? matchedContact.displayName
            : "Unknown";

        // الاستماع إلى تحديثات آخر رسالة والرسائل غير المقروءة
        fire
            .collection("users")
            .doc(Constants.userID)
            .collection("Chat")
            .doc(uid)
            .collection("Messages")
            .orderBy("date", descending: true)
            .snapshots()
            .listen((snapshot) async {
          String lastMessage = "No messages yet";
          DateTime? lastMessageDate;
          int unreadCount = 0;

          if (snapshot.docs.isNotEmpty) {
            var lastMessageData =
                snapshot.docs.first.data() as Map<String, dynamic>;
            lastMessage = lastMessageData["content"] ?? "";
            lastMessageDate = lastMessageData["date"].toDate();

            // حساب الرسائل غير المقروءة
            unreadCount = snapshot.docs.where((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return data["isRead"] == false;
            }).length;
          }

          // تحديث بيانات المستخدم في الدردشة
          chatUsers.removeWhere((user) => user['uid'] == uid);
          chatUsers.add({
            "uid": uid,
            "name": displayName,
            "phone": phoneNumber,
            "lastMessage": lastMessage,
            "lastMessageDate": lastMessageDate,
            "unreadCount": unreadCount,
          });

          // ترتيب الدردشات حسب أحدث رسالة
          chatUsers.sort((a, b) => (b["lastMessageDate"] ?? DateTime(0))
              .compareTo(a["lastMessageDate"] ?? DateTime(0)));

          emit(ChatContactLoaded(chatUsers));
        });
      }
    } catch (e) {
      emit(ChatContactError("❌ Failed to fetch matched contacts: $e"));
    }
  }
}
