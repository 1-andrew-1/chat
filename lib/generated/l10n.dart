// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to ChatApp`
  String get Welcome_Screen_text1 {
    return Intl.message(
      'Welcome to ChatApp',
      name: 'Welcome_Screen_text1',
      desc: '',
      args: [],
    );
  }

  /// `Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.`
  String get Welcome_Screen_privacy_text {
    return Intl.message(
      'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
      name: 'Welcome_Screen_privacy_text',
      desc: '',
      args: [],
    );
  }

  /// `Agree and continue`
  String get Welcome_Screen_button {
    return Intl.message(
      'Agree and continue',
      name: 'Welcome_Screen_button',
      desc: '',
      args: [],
    );
  }

  /// `Get started.`
  String get PhoneAuthScreen_text1 {
    return Intl.message(
      'Get started.',
      name: 'PhoneAuthScreen_text1',
      desc: '',
      args: [],
    );
  }

  /// `PHONE NUMBER`
  String get PhoneAuthScreen_text2 {
    return Intl.message(
      'PHONE NUMBER',
      name: 'PhoneAuthScreen_text2',
      desc: '',
      args: [],
    );
  }

  /// `OTP Sent Successfully!`
  String get PhoneAuthScreen_text3 {
    return Intl.message(
      'OTP Sent Successfully!',
      name: 'PhoneAuthScreen_text3',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get PhoneAuthScreen_button {
    return Intl.message(
      'Send OTP',
      name: 'PhoneAuthScreen_button',
      desc: '',
      args: [],
    );
  }

  /// `Verification Code`
  String get OTPVerificationPage_title {
    return Intl.message(
      'Verification Code',
      name: 'OTPVerificationPage_title',
      desc: '',
      args: [],
    );
  }

  /// `We texted you a code\nPlease enter it below`
  String get OTPVerificationPage_text {
    return Intl.message(
      'We texted you a code\nPlease enter it below',
      name: 'OTPVerificationPage_text',
      desc: '',
      args: [],
    );
  }

  /// `This helps us verify every user in our marketplace`
  String get OTPVerificationPage_text1 {
    return Intl.message(
      'This helps us verify every user in our marketplace',
      name: 'OTPVerificationPage_text1',
      desc: '',
      args: [],
    );
  }

  /// `Didn't get code?`
  String get OTPVerificationPage_text2 {
    return Intl.message(
      'Didn\'t get code?',
      name: 'OTPVerificationPage_text2',
      desc: '',
      args: [],
    );
  }

  /// `✅ Verification successful! Redirecting to home...`
  String get OTPVerificationPage_text3 {
    return Intl.message(
      '✅ Verification successful! Redirecting to home...',
      name: 'OTPVerificationPage_text3',
      desc: '',
      args: [],
    );
  }

  /// `Cofirm`
  String get OTPVerificationPage_text4 {
    return Intl.message(
      'Cofirm',
      name: 'OTPVerificationPage_text4',
      desc: '',
      args: [],
    );
  }

  /// `Let's get you set up.`
  String get ProfileSetupScreen_text {
    return Intl.message(
      'Let\'s get you set up.',
      name: 'ProfileSetupScreen_text',
      desc: '',
      args: [],
    );
  }

  /// `PROFILE IMAGE`
  String get ProfileSetupScreen_text1 {
    return Intl.message(
      'PROFILE IMAGE',
      name: 'ProfileSetupScreen_text1',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get ProfileSetupScreen_button {
    return Intl.message(
      'Browse',
      name: 'ProfileSetupScreen_button',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get ProfileSetupScreenfirst_name_text {
    return Intl.message(
      'First name',
      name: 'ProfileSetupScreenfirst_name_text',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get ProfileSetupScreenlast_name_text {
    return Intl.message(
      'Last name',
      name: 'ProfileSetupScreenlast_name_text',
      desc: '',
      args: [],
    );
  }

  /// `Complete setup`
  String get ProfileSetupScreen_text_button {
    return Intl.message(
      'Complete setup',
      name: 'ProfileSetupScreen_text_button',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
