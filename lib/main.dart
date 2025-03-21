import 'package:chatapp/controller/delete_message.dart';
import 'package:chatapp/controller/users%20status/chat_contact_cubit.dart';
import 'package:chatapp/controller/sharedpref/shared_preferences_cubit.dart';
import 'package:chatapp/controller/cubit_unsing/pages/page_controller_cubit.dart';
import 'package:chatapp/controller/cubit_unsing/select%20numbet%20code/cubit/selectnumbercode_cubit.dart';
import 'package:chatapp/core/services/cubit/auth_cubit.dart';
import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/views/screens/home/homeseceen.dart';
import 'package:chatapp/views/screens/splashviews/welcome_screen.dart';
import 'package:chatapp/views/themes/dark_theme.dart';
import 'package:chatapp/views/themes/light_themes.dart';
import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PageControllerCubit()),
        BlocProvider(create: (context) => SharedPreferencesCubit()..loadUid()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => SelectnumbercodeCubit()),
        BlocProvider(create: (context) => DeleteMessageCubit()),
      ],
      child: BlocBuilder<SharedPreferencesCubit, SharedPreferencesState>(
        builder: (context, state) {
          // 🔹 تحقق مما إذا كانت البيانات جاهزة
          if (state is SharedPreferencesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔹 استخراج القيم المحفوظة
          final bool isDark = (state is ThemeUpdate) ? state.isDark : false;
          final String local = (state is ThemeUpdate) ? state.local : "en";
          final bool isLogin = (state is ThemeUpdate) ? state.islogin : false;

          return MaterialApp(
            supportedLocales: const [
              Locale('en'), Locale('ar'), Locale('fr'), Locale('es'), Locale('de'),
            ],
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: Locale(local),
            debugShowCheckedModeBanner: false,
            theme: isDark ? DarkTheme.theme : LightTheme.theme,
            home: isLogin
                ? BlocProvider(create: (context) => ChatContactCubit(), child: const HomeScreen())
                : const WelcomeScreen(),
          );
        },
      ),
    );
  }
}



