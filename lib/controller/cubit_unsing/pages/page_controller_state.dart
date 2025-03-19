part of 'page_controller_cubit.dart';

@immutable
sealed class PageControllerState {}

final class PageControllerInitial extends PageControllerState {}

final class PageControllerSelect extends PageControllerState {
  final int index;
  final String title;
  PageControllerSelect({required this.index , required this.title });
}

