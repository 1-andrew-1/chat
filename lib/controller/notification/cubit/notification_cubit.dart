import 'package:chatapp/controller/fetching_message/cubit/fetching_message_cubit.dart';
import 'package:chatapp/controller/send_message/cubit/chat_cubit.dart';
import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/views/screens/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  static final NotificationCubit _instance = NotificationCubit._internal();
  factory NotificationCubit() => _instance;
  String _tittle = '';
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _permissionRequested = false;
  String? _currentChatUserID; // Track the currently open chat

  NotificationCubit._internal() : super(NotificationInitial()) {
    _initNotifications();
  }

  /// **Initialize Local Notifications**
  Future<void> _initNotifications() async {
    if (_permissionRequested) return;
    _permissionRequested = true;

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          handleNotificationTap(response.payload!, _tittle);
        }
      },
    );

    final androidPlugin =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      bool? granted = await androidPlugin.requestNotificationsPermission();
      if (granted == false) {
        print("Notification permission denied!");
      }
    }
  }

  /// **Set the currently open chat user ID**
  void setCurrentChatUser(String? userID) {
    _currentChatUserID = userID;
    if (userID != null) {
      // Cancel all active notifications when opening the chat
      _flutterLocalNotificationsPlugin.cancelAll();
      print("All notifications cleared for user $userID.");
    }
  }

  /// **Show Notification (Only if user is not in the chat)**
  Future<void> showNotification({
    required String senderID,
    required String title,
    required String body,
    String? payload,
  }) async {
    _tittle = title;
    if (_currentChatUserID == senderID) {
      print("User is already in chat with $senderID. No notification sent.");
      return;
    }

    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'chat_channel', // Unique channel ID
        'Chat Notifications', // Channel name
        channelDescription:
            'This channel is used for chat message notifications.',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidDetails);

      int notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(100000);

      await _flutterLocalNotificationsPlugin.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      emit(NotificationSent(title, body));
    } catch (e) {
      print("Notification Error: $e");
    }
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// **Handle Notification Tap**
  void handleNotificationTap(String payload, String title) {
    print("==================== Notification tapped! Payload: $payload");

    Future.delayed(const Duration(milliseconds: 500), () {
      final context = MyApp.navigatorKey.currentContext;
      if (context != null) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => FetchingMessageCubit()
                    ..fetchMessages(receiverID: payload),
                ),
                BlocProvider(
                  create: (context) => ChatCubit()..init(receiverID: payload),
                ),
              ],
              child: ChatScreen(
                title: title,
                receiverID: payload,
                userID: Constants.userID,
              ),
            ),
          ),
        );
      } else {
        print("========= Error: Context is null, cannot navigate.");
      }
    });
  }
}
