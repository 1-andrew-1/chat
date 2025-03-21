import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/views/widgets/snack_bar_custom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteMessageCubit extends Cubit<void> {
  DeleteMessageCubit() : super(null);
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  void showDeleteOptions(BuildContext context, String receiverID,
      String senderid, String messageid) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(S.of(context).deleteForMe),
              onTap: () {
                showConfirmationDialog(
                    context, S.of(context).deleteForMe, receiverID, messageid);
              },
            ),
            Visibility(
                visible: Constants.userID == senderid,
                child: ListTile(
                  leading:
                      const Icon(Icons.delete_forever, color: Colors.redAccent),
                  title: Text(S.of(context).deleteForEveryone),
                  onTap: () {
                    showConfirmationDialog(context,
                        S.of(context).deleteForEveryone, receiverID, senderid);
                  },
                ))
          ],
        );
      },
    );
  }

  void showConfirmationDialog(BuildContext context, String deleteType,
      String receiverID, String messageid) {
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.warning,
      title: S.of(context).deleteConfirmation,
      desc: S.of(context).deleteMessage(deleteType),
      btnCancelText: S.of(context).cancel,
      btnCancelOnPress: () {
        Navigator.pop(context);
      },
      btnOkText: S.of(context).confirmDelete,
      btnOkOnPress: () {
        if (deleteType == S.of(context).deleteForMe) {
          deleteMessage(context, receiverID, messageid, Constants.userID);
        } else {
          deleteMessage(context, receiverID, messageid, Constants.userID);
          deleteMessage(context, Constants.userID, messageid, receiverID);
        }
        print("${deleteType} ${S.of(context).deletedMessage}");
      },
    ).show();
  }

  Future<void> deleteMessage(BuildContext context, String receiverID,
      String messageID, String senderID) async {
    DocumentReference senderChatRef = FirebaseFirestore.instance
        .collection("users")
        .doc(senderID)
        .collection("Chat")
        .doc(receiverID);

    try {
      await senderChatRef.collection("Messages").doc(messageID).delete();
      // ignore: use_build_context_synchronously
      showCustomSnackBar(context, "Message deleted successfully");
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      showCustomSnackBar(context, "Error deleting message: $e");
      Navigator.pop(context);
    }
  }
  
}
