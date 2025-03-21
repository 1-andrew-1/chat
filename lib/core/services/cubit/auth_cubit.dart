import 'package:chatapp/core/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;
  String? _verificationId;
  bool otpSent = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  AuthCubit() : super(AuthInitial()) {
    _initSharedPreferences();
  }

  String verificationCode = '';
  String userId = '';
  String phone = '';

  // Initialize SharedPreferences
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Step 1: Send OTP
  Future<void> sendOTP(String phoneNumber) async {
    emit(AuthLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          emit(AuthSuccess(userCredential.user!.uid));
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthError(e.message ?? "Verification failed"));
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          emit(OTPSent());
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      emit(AuthError("Failed to send OTP"));
    }
  }

  // Step 2: Verify OTP
  Future<void> verifyOTP(String smsCode) async {
    if (_verificationId == null) {
      emit(AuthError("No verification ID found"));
      return;
    }

    emit(AuthLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      emit(AuthSuccess(userCredential.user!.uid));
    } catch (e) {
      emit(AuthError("Invalid OTP"));
    }
  }

  // Store user data in SharedPreferences
  Future<void> saveUserData(

      String userName, String userUID, String phoneNumber) async {
      await _prefs.setString('username', userName);
      await _prefs.setString('user_uid', userUID);
      await _prefs.setString('phonenumber', phoneNumber);
      Constants.userID = userUID;
  }

  // Save user to Firestore
  Future<void> saveUserToFirestore(String userId, String phoneNumber) async {
    try {
      DocumentReference userRef = firestore.collection("users").doc(userId);
      DocumentSnapshot userSnapshot = await userRef.get();
      Constants.is_exists = userSnapshot.exists;
      if (userSnapshot.exists) {
        // Update login time
        saveUserData("andrew", userId, phoneNumber);
        await userRef.update({
          "lastLoginAt": FieldValue.serverTimestamp(),
        });
        print(
            "User login time updated successfully! ${_prefs.getString('user_uid')}");
      } else {
        // Create new user
        saveUserData("andrew", userId, phoneNumber);
        await userRef.set({
          "userId": userId,
          "phoneNumber": phoneNumber,
          "createdAt": FieldValue.serverTimestamp(),
          "lastLoginAt": FieldValue.serverTimestamp(),
        });
        print("========================== User saved successfully! $userId");
      }
    } catch (e) {
      print("Error saving user: $e");
    }
  }
}
