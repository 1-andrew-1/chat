part of 'notification_cubit.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationInitialized extends NotificationState {}

class NotificationSent extends NotificationState {
  final String title;
  final String body;

  NotificationSent(this.title, this.body);
}

class NotificationClicked extends NotificationState {
  final String payload;

  NotificationClicked(this.payload);
}
