import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/views/screens/splashviews/phone_auth_screen.dart';
import 'package:chatapp/views/widgets/custom_button.dart';
import 'package:chatapp/views/widgets/custom_page_route.dart';
import 'package:chatapp/views/widgets/custom_text.dart';
import 'package:chatapp/views/widgets/select_language_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 120,
              backgroundImage: const AssetImage('assets/images/1.webp'),
              backgroundColor: Colors.green.shade100,
            ),
            const SizedBox(height: 40),
            Text(
              S.of(context).Welcome_Screen_text1,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              S.of(context).Welcome_Screen_privacy_text,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // زر اختيار اللغة
            Builder(
              builder: (context) => const SelectLanguageButton(),
            ),
            const SizedBox(height: 20),

            // زر الموافقة والمتابعة
            CustomButtonAuth(
              onPressed: () {
                navigateTo(context, const PhoneAuthScreen());
              },
              childWidget: CustomText(
                text: S.of(context).Welcome_Screen_button,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
