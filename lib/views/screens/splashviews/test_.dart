import 'package:chatapp/core/services/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool otpSent = false; // Flag to track OTP step

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Phone Authentication")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is OTPSent) {
            setState(() {
              otpSent = true; // Show OTP input field
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("OTP Sent!")));
          } else if (state is AuthSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Authentication Successful!")));
            // Navigate to the next screen
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!otpSent) ...[
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      prefixText: "+",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().sendOTP(phoneController.text.trim());
                    },
                    child: state is AuthLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Send OTP"),
                  ),
                ] else ...[
                  TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter OTP",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthCubit>().verifyOTP(otpController.text.trim());
                    },
                    child: state is AuthLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Verify OTP"),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
