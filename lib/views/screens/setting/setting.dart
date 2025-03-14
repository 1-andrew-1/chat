import 'package:chatapp/controller/sharedpref/shared_preferences_cubit.dart';
import 'package:chatapp/views/screens/splashviews/phone_auth_screen.dart';
import 'package:chatapp/views/widgets/custom_page_route.dart';
import 'package:chatapp/views/widgets/custom_profile_button.dart';
import 'package:chatapp/views/widgets/dark_light_mode.dart';
import 'package:chatapp/views/widgets/log_out_button.dart';
import 'package:chatapp/views/widgets/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
   
  @override
  Widget build(BuildContext context)  {
    final sharedpre = BlocProvider.of<SharedPreferencesCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
       actions:const [
           DarkLightMode() ,
        ],
      ),
      body:   Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const ProfileCard(),
            const SizedBox(height: 10),
            const Text(
              "Jane Doe",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "This is a small bio description to let users\nexpress themselves",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 25),
            CustomProfileButton(iconData:Icons.key_outlined ,textname: "Account" , callback: () {}, ) ,
            CustomProfileButton(iconData:Icons.chat_outlined ,textname: "Chat Settings" , callback: () {}, ) ,
            CustomProfileButton(iconData:Icons.notifications ,textname: "Natification" , callback: () {}, ) ,
            CustomProfileButton(iconData:Icons.storage ,textname: "Storge" , callback: () {}, ) ,
            CustomProfileButton(iconData:Icons.language ,textname: "App language" , callback: () {}, ) ,
            CustomProfileButton(iconData:Icons.help_center_outlined ,textname: "Helps" , callback: () {}, ) ,
            CustomProfileButton(iconData:Icons.chat_outlined ,textname: "Invate a friend" , callback: () {}, ) ,
            const SizedBox(height: 50) ,
            LogoutButton(onPressed: () {
              sharedpre.logout();
              navigateOffAll(context, const PhoneAuthScreen());
            } ) ,
          ],
        ),
      ),
    );
  }
}
