// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(deleteType) => "هل أنت متأكد أنك تريد ${deleteType}؟";

  static String m1(deleteType) => "${deleteType} تم الحذف";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "OTPVerificationPage_text": MessageLookupByLibrary.simpleMessage(
      "لقد أرسلنا لك رمزًا\nالرجاء إدخاله أدناه",
    ),
    "OTPVerificationPage_text1": MessageLookupByLibrary.simpleMessage(
      "يساعدنا هذا في التحقق من كل مستخدم في منصتنا",
    ),
    "OTPVerificationPage_text2": MessageLookupByLibrary.simpleMessage(
      "لم تستلم الرمز؟",
    ),
    "OTPVerificationPage_text3": MessageLookupByLibrary.simpleMessage(
      "✅ تم التحقق بنجاح! جارٍ التوجيه إلى الصفحة الرئيسية...",
    ),
    "OTPVerificationPage_text4": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "OTPVerificationPage_title": MessageLookupByLibrary.simpleMessage(
      "رمز التحقق",
    ),
    "PhoneAuthScreen_button": MessageLookupByLibrary.simpleMessage("إرسال OTP"),
    "PhoneAuthScreen_text1": MessageLookupByLibrary.simpleMessage("لنبدأ."),
    "PhoneAuthScreen_text2": MessageLookupByLibrary.simpleMessage("رقم الهاتف"),
    "PhoneAuthScreen_text3": MessageLookupByLibrary.simpleMessage(
      "تم إرسال رمز OTP بنجاح!",
    ),
    "ProfileSetupScreen_button": MessageLookupByLibrary.simpleMessage("تصفح"),
    "ProfileSetupScreen_text": MessageLookupByLibrary.simpleMessage(
      "لنقم بإعداد ملفك الشخصي.",
    ),
    "ProfileSetupScreen_text1": MessageLookupByLibrary.simpleMessage(
      "صورة الملف الشخصي",
    ),
    "ProfileSetupScreen_text_button": MessageLookupByLibrary.simpleMessage(
      "إكمال الإعداد",
    ),
    "ProfileSetupScreenfirst_name_text": MessageLookupByLibrary.simpleMessage(
      "الاسم الأول",
    ),
    "ProfileSetupScreenlast_name_text": MessageLookupByLibrary.simpleMessage(
      "اسم العائلة",
    ),
    "Welcome_Screen_button": MessageLookupByLibrary.simpleMessage(
      "موافقة ومتابعة",
    ),
    "Welcome_Screen_privacy_text": MessageLookupByLibrary.simpleMessage(
      "اقرأ سياسة الخصوصية. اضغط على \"موافقة ومتابعة\" لقبول شروط الخدمة.",
    ),
    "Welcome_Screen_text1": MessageLookupByLibrary.simpleMessage(
      "مرحبًا بك في ChatApp",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "confirmDelete": MessageLookupByLibrary.simpleMessage("نعم، احذف"),
    "deleteConfirmation": MessageLookupByLibrary.simpleMessage("تأكيد الحذف"),
    "deleteForEveryone": MessageLookupByLibrary.simpleMessage("حذف للجميع"),
    "deleteForMe": MessageLookupByLibrary.simpleMessage("حذف لي فقط"),
    "deleteMessage": m0,
    "deletedMessage": m1,
  };
}
