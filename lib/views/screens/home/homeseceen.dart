import 'package:chatapp/controller/users%20status/chat_contact_cubit.dart';
import 'package:chatapp/controller/contacts/cubit/phonecontact_cubit.dart';
import 'package:chatapp/views/screens/searching/searching.dart';
import 'package:chatapp/views/widgets/custom_page_route.dart';
import 'package:chatapp/views/widgets/personal_chat_title.dart';
import 'package:chatapp/views/widgets/profile_button_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats'), actions: const [
        ProfileButtonIcon(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(
            context,
            BlocProvider(
              create: (context) => PhonecontactCubit(),
              child: const Searching(),
            ),
          );
        },
        child: const Icon(Icons.chat_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ChatContactCubit, ChatContactState>(
          builder: (context, state) {
            if (state is ChatContactLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatContactLoaded) {
              if (state.chatUsers.isEmpty) {
                return const Center(
                    child: Text("No chats found. Let's start!"));
              }
              return ListView.builder(
                shrinkWrap: true, // ✅ Prevents unnecessary re-renders
                physics: const BouncingScrollPhysics(), // ✅ Smooth scrolling
                itemCount: state.chatUsers.length,
                itemBuilder: (context, index) {
                  final contact = state.chatUsers[index];
                  return PersonalChatTitle(
                    title: contact['name'],
                    subtitle: contact['lastMessage'],
                    UID: contact['uid'],
                    unreadCount:
                        contact['unreadCount'], // عرض عدد الرسائل غير المقروءة
                  );
                },
              );
            } else if (state is ChatContactError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
