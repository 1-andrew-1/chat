import 'package:chatapp/core/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'chat_contact_state.dart';

class ChatContactCubit extends Cubit<ChatContactState> {
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  List<Contact> contacts = []; // Store device contacts

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

// Fetch receiver UIDs from Firestore
  Future<List<String>> getChatReceiverUIDs() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(Constants.userID)
          .collection("Chat")
          .get();
      List<String> receiverUIDs = [];
      for (var doc in snapshot.docs) {
        receiverUIDs.add(doc.id); // Receiver ID
      }

      return receiverUIDs;
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

  /// Fetch and match contacts with Firebase users
  Future<void> fetchMatchedChatContacts() async {
    if (contacts.isEmpty) return; // Ensure contacts are loaded

    emit(ChatContactLoading());

    try {
      List<String> receiverUIDs = await getChatReceiverUIDs();
      if (receiverUIDs.isEmpty) {
        emit(ChatContactLoaded(const [])); // No chat users found
        return;
      }
      // Fetch user details from Firestore
      List<DocumentSnapshot> userDocs = await Future.wait(
        receiverUIDs.map((uid) => fire.collection("users").doc(uid).get()),
      );

      List<Map<String, dynamic>> chatUsers =
          userDocs.where((doc) => doc.exists).map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>? ?? {};
        return {
          "uid": doc.id,
          "phone": data["phoneNumber"] ?? "",
        };
      }).toList();

// Match chat users with local contacts
      List<Map<String, dynamic>> matchedChatUsers = chatUsers.map((chatUser) {
        String phoneNumber = chatUser["phone"] ?? "";

        // Find matching contact by phone number
        Contact? matchedContact = contacts.firstWhere(
          (contact) => contact.phones.any(
            (phone) => phone.number.replaceAll(" ", "").contains(phoneNumber),
          ),
          orElse: () => Contact(),
        );

        return {
          "uid": chatUser["uid"],
          "name": matchedContact.displayName.isNotEmpty
              ? matchedContact.displayName
              : "Unknown",
          "phone": phoneNumber,
        };
      }).toList();

      emit(ChatContactLoaded(matchedChatUsers));
    } catch (e) {
      emit(ChatContactError("❌ Failed to fetch matched contacts: $e"));
    }
  }
}
