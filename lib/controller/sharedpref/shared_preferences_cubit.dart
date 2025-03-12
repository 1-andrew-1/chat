import 'package:chatapp/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

part 'shared_preferences_state.dart';

class SharedPreferencesCubit extends Cubit<SharedPreferencesState> {
  late SharedPreferences _prefs; // ✅ تخزين SharedPreferences مرة واحدة
  SharedPreferencesCubit() : super(SharedPreferencesInitial()) {
    _initPreferences();
    initDatabase();
  }
  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    Constants.userID = _prefs.getString('user_uid') ?? "";
    bool isDark = _prefs.getBool('isDark') ?? false;
    bool islogin = _prefs.getBool('islogin') ?? false;
    String local = _prefs.getString('local') ?? "en";
    emit(ThemeUpdate(
        isDark: isDark,
        local: local,
        islogin: islogin)); // تحميل الثيم عند التهيئة
  }

  Future<void> changeTheme() async {
    bool isDark = _prefs.getBool('isDark') ?? false;
    bool islogin = _prefs.getBool('isDark') ?? false;
    String local =
        _prefs.getString('local') ?? "en"; // ✅ الاحتفاظ باللغة المخزنة
    await _prefs.setBool('isDark', !isDark);
    emit(ThemeUpdate(isDark: !isDark, local: local, islogin: islogin));
  }

  String language = "English";
  Future<void> changeLocal(String local) async {
    bool islogin = _prefs.getBool('isDark') ?? false;
    bool isDark = _prefs.getBool('isDark') ?? false; // ✅ الاحتفاظ بالثيم المخزن
    await _prefs.setString('local', local);
    emit(ThemeUpdate(isDark: isDark, local: local, islogin: islogin));
  }

  void setUserUid(String uid) {
    _prefs.setString('user_uid', uid);
  }

  void islogin() async {
    await _prefs.setBool('islogin', true);
  }

  void logout() async {
    await _prefs.setBool('islogin', false);
    _prefs.setString('user_uid', "");
  }

  // create a database
  Future<void> initDatabase() async {
    bool isDbCreated = _prefs.getBool('isDbCreated') ?? false;

    if (!isDbCreated) {
      await openDatabase(
        'chatapp.db',
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            senderID TEXT,
            receiverID TEXT,
            content TEXT, 
            filePath TEXT,   -- Path of the file
            fileType TEXT,   -- (image, video, audio, pdf)
            timestamp TEXT,
            isRead INTEGER
          )
        ''');
        },
      );

      // Mark database as created
      await _prefs.setBool('isDbCreated', true);
      debugPrint("✅ Database Created Successfully");
    } else {
      debugPrint("📌 Database already exists, skipping creation");
    }
  }
}
