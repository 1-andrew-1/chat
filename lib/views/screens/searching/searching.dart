import 'package:chatapp/controller/contacts/cubit/phonecontact_cubit.dart';
import 'package:chatapp/views/screens/searching/text_widget.dart';
import 'package:chatapp/views/widgets/personal_chat_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Searching extends StatelessWidget {
  const Searching({super.key});
  String _normalizePhoneNumber(String number) {
    return number.replaceAll(RegExp(r"[^\d+]"), ""); // Keep only '+' and digits
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select contact",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),
              Text(
                "652 contact",
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.green,
                radius: 24,
                child: Icon(Icons.group_add, color: Colors.white, size: 28),
              ),
              title: const Text(
                "New group",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              onTap: () {
                // Add navigation or function here
              },
            ),
            Expanded(
              child: BlocBuilder<PhonecontactCubit, PhonecontactState>(
                builder: (context, state) {
                  if (state is PhonecontactLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is PhonecontactLoaded) {
                    final registeredCount = state.registeredContacts.length;
                    final nonRegisteredCount =
                        state.nonRegisteredContacts.length;
                    bool hasRegistered = registeredCount > 0;
                    bool hasNonRegistered = nonRegisteredCount > 0;

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: registeredCount +
                          nonRegisteredCount +
                          (hasRegistered ? 1 : 0) + // Header for registered
                          (hasNonRegistered
                              ? 1
                              : 0), // Header for non-registered
                      itemBuilder: (context, index) {
                        // Registered Contacts Header
                        if (hasRegistered && index == 0) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: TextWidget(text: 'Registered Contacts'),
                          );
                        }
                        // Non-Registered Contacts Header
                        if (hasNonRegistered &&
                            index ==
                                registeredCount + (hasRegistered ? 1 : 0)) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: TextWidget(text: 'Non-Registered Contacts'),
                          );
                        }

                        // Adjust index to ignore headers
                        int adjIndex = index - (hasRegistered ? 1 : 0);

                        // Registered Contacts
                        if (adjIndex < registeredCount) {
                          final contact = state.registeredContacts[adjIndex];

                          // Normalize phone number to match Firebase format
                          final phone = contact.phones.isNotEmpty
                              ? _normalizePhoneNumber(
                                  contact.phones.first.number)
                              : "No phone number";

                          final uid = state.registeredContactsDetails[phone]
                                  ?["userId"] ??
                              "No UID"; // Ensure UID is always available

                          return PersonalChatTitle(
                            title: contact.displayName,
                            subtitle: phone,
                            UID: uid, unreadCount: 0,
                          );
                        }

                        // Non-Registered Contacts
                        int nonRegisteredIndex = adjIndex -
                            registeredCount -
                            (hasNonRegistered ? 1 : 0);
                        final contact =
                            state.nonRegisteredContacts[nonRegisteredIndex];
                        final phone = contact.phones.isNotEmpty
                            ? contact.phones.first.number
                            : "No phone number";
                        return ListTile(
                          leading: const Icon(Icons.person_outline,
                              color: Colors.grey),
                          title: Text(contact.displayName),
                          subtitle: Text(phone),
                        );
                      },
                    );
                  }
                  if (state is PhonecontactError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(
                      child: Text("Press a button to load contacts"));
                },
              ),
            ),
          ],
        ));
  }
}
/*
ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              radius: 24,
              child: Icon(Icons.group_add, color: Colors.white, size: 28),
            ),
            title: const Text(
              "New group",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              // Add navigation or function here
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Contacts on WhatsApp",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(
                        'assets/images/AVA.jpeg'), // Replace with your image
                  ),
                  title: const Text(
                    "أندرو (You)",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Message yourself",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  onTap: () {
                    // Add navigation or function here
                  },
                ),
                
              ],
            ),
          ),
        ],
      ),

*/
/*
  BlocBuilder<PhonecontactCubit, PhonecontactState>(
        builder: (context, state) {
          if (state is PhonecontactLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PhonecontactLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // Registered Contacts Section
                      if (state.registeredContacts.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Registered Contacts",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...state.registeredContacts.map((contact) {
                          String phone = contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : "No phone number";
                          return PersonalChatTitle(title: Text(contact.displayName),
                            subtitle: Text(phone),) 
                          ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.green),
                            title: Text(contact.displayName),
                            subtitle: Text(phone),
                          );
                        }).toList(),
                      ],

                      // Non-Registered Contacts Section
                      if (state.nonRegisteredContacts.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Non-Registered Contacts",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...state.nonRegisteredContacts.map((contact) {
                          String phone = contact.phones.isNotEmpty
                              ? contact.phones.first.number
                              : "No phone number";
                          return ListTile(
                            leading: const Icon(Icons.person_outline,
                                color: Colors.grey),
                            title: Text(contact.displayName),
                            subtitle: Text(phone),
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                ),
              ],
            );
          } else if (state is PhonecontactError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Press a button to load contacts"));
        },
      ),
*/