import 'package:chatapp/controller/users%20status/chat_contact_cubit.dart';
import 'package:chatapp/controller/sharedpref/shared_preferences_cubit.dart';
import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/core/services/cubit/auth_cubit.dart';
import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/views/screens/home/homeseceen.dart';
import 'package:chatapp/views/screens/splashviews/profile_setup_screen.dart';
import 'package:chatapp/views/widgets/custom_button.dart';
import 'package:chatapp/views/widgets/custom_page_route.dart';
import 'package:chatapp/views/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class OTPVerificationPage extends StatelessWidget {
  const OTPVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    final sharedpre = BlocProvider.of<SharedPreferencesCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).OTPVerificationPage_title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.security,
                size: 110,
              ),
              const SizedBox(height: 30),
              Text(
                S.of(context).OTPVerificationPage_text,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFF512DA8),
                showFieldAsBox: true,
                fieldWidth: 50,
                handleControllers: (controllers) {
                  authCubit.verificationCode = (controllers[0]?.text ?? '') +
                      (controllers[1]?.text ?? '') +
                      (controllers[2]?.text ?? '') +
                      (controllers[3]?.text ?? '') +
                      (controllers[4]?.text ?? '') +
                      (controllers[5]?.text ?? '');
                },
                borderRadius: BorderRadius.circular(12),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                onCodeChanged: (String code) {},
              ),
              const SizedBox(height: 25),
              Text(
                S.of(context).OTPVerificationPage_text1,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: Text(S.of(context).OTPVerificationPage_text2,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoading) {
                    authCubit.otpSent = true;
                  } else if (state is AuthSuccess) {
                    authCubit.otpSent = false;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text(S.of(context).OTPVerificationPage_text3)));

                    authCubit
                        .saveUserToFirestore(state.uid, authCubit.phone)
                        .then((_) {
                      sharedpre.islogin();
                      navigateOffAll(
                        context,
                        BlocProvider(
                          create: (context) => ChatContactCubit(),
                          child: Constants.is_exists
                              ? const HomeScreen()
                              : const ProfileSetupScreen(),
                        ),
                      );
                    }).catchError((error) {
                      print("Error saving user: $error");
                    });
                  } else if (state is AuthError) {
                    authCubit.otpSent = false;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return CustomButtonAuth(
                    childWidget: authCubit.otpSent
                        ? const CircularProgressIndicator(color: Colors.white)
                        : CustomText(
                            text: S.of(context).OTPVerificationPage_text4),
                    onPressed: () {
                      authCubit.verifyOTP(authCubit.verificationCode);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
