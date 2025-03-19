part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OTPSent extends AuthState {}

class AuthSuccess extends AuthState {
  String uid ;
  AuthSuccess(this.uid);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
