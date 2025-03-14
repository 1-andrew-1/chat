part of 'phonecontact_cubit.dart';

@immutable
sealed class PhonecontactState {}

final class PhonecontactInitial extends PhonecontactState {}

final class PhonecontactLoading extends PhonecontactState {}

final class PhonecontactLoaded extends PhonecontactState {
  final List<Contact> registeredContacts;
  final List<Contact> nonRegisteredContacts;
  final Map<String, Map<String, String>> registeredContactsDetails;

  PhonecontactLoaded(
      this.registeredContacts, this.nonRegisteredContacts, this.registeredContactsDetails);
}

final class PhonecontactError extends PhonecontactState {
  final String message;
  
  PhonecontactError(this.message);
}
