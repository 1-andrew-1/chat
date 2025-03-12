import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'phonecontact_state.dart';

class PhonecontactCubit extends Cubit<PhonecontactState> {
  PhonecontactCubit() : super(PhonecontactInitial()) {
    fetchRegisteredContacts();
  }

  List<Contact> registeredContacts = [];
  List<Contact> nonRegisteredContacts = [];
  List<Contact> contacts = [];
  Map<String, Map<String, String>> registeredContactsDetails = {};

  Future<void> fetchRegisteredContacts() async {
    emit(PhonecontactLoading()); // Notify UI that fetching is in progress

    try {
      bool permissionGranted = await FlutterContacts.requestPermission();
      if (!permissionGranted) {
        emit(PhonecontactError("Permission denied. Enable contacts permission."));
        return;
      }

      contacts =
          await FlutterContacts.getContacts(withProperties: true);

      if (contacts.isEmpty) {
        emit(PhonecontactError("No contacts found on the device."));
        return;
      }

      // Extract and normalize phone numbers
      List<String> phoneNumbers = contacts
          .where((c) => c.phones.isNotEmpty)
          .map((c) => _normalizePhoneNumber(c.phones.first.number))
          .toList();

      if (phoneNumbers.isEmpty) {
        emit(PhonecontactError("No valid phone numbers found."));
        return;
      }

      // Fetch registered users from Firebase
      var querySnapshot = await FirebaseFirestore.instance.collection("users").get();

      // Extract registered users with their details
      Map<String, Map<String, String>> registeredNumbers = {};
      for (var doc in querySnapshot.docs) {
        String phone = _normalizePhoneNumber(doc["phoneNumber"] ?? "");
        if (phone.isEmpty) continue;
        registeredNumbers[phone] = {
          "userId": doc.id,
          "phone": phone,
        };
        print("✅ Registered User - Phone: $phone, UID: ${registeredNumbers[phone]?["userId"]}");
      }
      // Clear previous lists to avoid duplicates
      registeredContacts.clear();
      nonRegisteredContacts.clear();
      registeredContactsDetails.clear();

      for (var contact in contacts) {
        if (contact.phones.isEmpty) continue; // Skip contacts with no phone numbers
        String contactNumber = _normalizePhoneNumber(contact.phones.first.number);
        if (contactNumber.isNotEmpty) {
          if (registeredNumbers.containsKey(contactNumber)) {
            registeredContacts.add(contact);
            registeredContactsDetails[contactNumber] = registeredNumbers[contactNumber]!;
          } else {
            nonRegisteredContacts.add(contact);
          }
        }
      }

      // Emit success state with data
      emit(PhonecontactLoaded(registeredContacts, nonRegisteredContacts, registeredContactsDetails));
    } catch (e) {
      emit(PhonecontactError("Error fetching contacts: ${e.toString()}"));
    }
  }

  // Helper function to normalize phone numbers (removes spaces & special chars)
  String _normalizePhoneNumber(String number) {
    return number.replaceAll(RegExp(r"[^\d+]"), ""); // Keep only '+' and digits
  }

}
