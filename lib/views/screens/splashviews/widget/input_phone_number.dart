import 'package:chatapp/controller/cubit_unsing/select%20numbet%20code/cubit/selectnumbercode_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InputPhoneNumber extends StatelessWidget {
  const InputPhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectnumbercodeCubit, SelectnumbercodeState>(
      builder: (context, state) {
        final cubit = context.read<SelectnumbercodeCubit>(); 
        return InternationalPhoneNumberInput(
          onInputChanged: cubit.updatePhoneNumber,
          onInputValidated: cubit.updateValidation,
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: Colors.black),
          initialValue: cubit.phoneNumber,
          textFieldController: cubit.phoneController,
          formatInput: true,
          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
          inputDecoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Phone Number",
          ),
        );
      },
    );
  }
}
