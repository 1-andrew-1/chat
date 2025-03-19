part of 'selectnumbercode_cubit.dart';

@immutable
sealed class SelectnumbercodeState {}

final class SelectnumbercodeInitial extends SelectnumbercodeState {}
class SelectnumbercodeUpdated extends SelectnumbercodeState {
  final PhoneNumber phoneNumber;
  final bool isValid;

  SelectnumbercodeUpdated(this.phoneNumber, this.isValid);
}