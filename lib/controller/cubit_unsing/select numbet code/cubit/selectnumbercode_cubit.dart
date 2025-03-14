import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
part 'selectnumbercode_state.dart';

class SelectnumbercodeCubit extends Cubit<SelectnumbercodeState> {
  SelectnumbercodeCubit() : super(SelectnumbercodeInitial());
  final TextEditingController phoneController = TextEditingController();
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'EG'); // Default phone number
  bool isValid = false; // Validation status

  void updatePhoneNumber(PhoneNumber number) {
    phoneNumber = number;
    emit(SelectnumbercodeUpdated(phoneNumber, isValid));
  }

  void updateValidation(bool valid) {
    isValid = valid;
    emit(SelectnumbercodeUpdated(phoneNumber, isValid));
  }
}
