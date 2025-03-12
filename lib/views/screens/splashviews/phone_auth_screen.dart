import 'package:chatapp/controller/cubit_unsing/select%20numbet%20code/cubit/selectnumbercode_cubit.dart';
import 'package:chatapp/core/services/cubit/auth_cubit.dart';
import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/views/screens/splashviews/otp_verfication_page.dart';
import 'package:chatapp/views/screens/splashviews/widget/input_phone_number.dart';
import 'package:chatapp/views/widgets/custom_page_route.dart';
import 'package:chatapp/views/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/views/widgets/custom_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit =
        context.read<SelectnumbercodeCubit>(); // Use existing cubit instance
    final authCubit = context.read<AuthCubit>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 350),
            const Icon(Icons.chat_bubble_outline,
                size: 40, color: Colors.purple),
            const SizedBox(height: 10),
             Text(
              S.of(context).PhoneAuthScreen_text1,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 150),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                S.of(context).PhoneAuthScreen_text2,
                style: TextStyle(
                    color: Colors.purple.shade300, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            // Country Selector Dropdown
            const InputPhoneNumber(),
            const SizedBox(height: 5),

            const SizedBox(height: 20),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                authCubit.otpSent = true;
                if (state is OTPSent) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar( SnackBar(content: Text( S.of(context).PhoneAuthScreen_text3,)));
                  Future.delayed(const Duration(milliseconds: 800), () {
                    authCubit.otpSent = false ;
                    // ignore: use_build_context_synchronously
                    navigateTo(context, const OTPVerificationPage());
                  });
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return CustomButtonAuth(
                  childWidget: authCubit.otpSent
                      ? const CircularProgressIndicator(color: Colors.white)
                      : CustomText(text: S.of(context).PhoneAuthScreen_button),
                  onPressed: () {
                    authCubit.phone = cubit.phoneNumber.phoneNumber.toString() ;
                    authCubit.sendOTP(cubit.phoneNumber.phoneNumber.toString());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
// BlocBuilder<SelectnumbercodeCubit, SelectnumbercodeState>(
//   builder: (context, state) {
//     String selectedCountry = '';
//     if ( state is SelectnumbercodeUpdated ) {
//       selectedCountry = state.selectedCountry;
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Text(
//           "Country set to $selectedCountry. ",
//           style:
//               const TextStyle(fontSize: 12, color: Colors.purple),
//         ),
//       ],
//     );
//   },
// ),
