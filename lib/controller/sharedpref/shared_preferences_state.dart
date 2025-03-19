part of 'shared_preferences_cubit.dart';

@immutable
sealed class SharedPreferencesState {}

final class SharedPreferencesInitial extends SharedPreferencesState {}
final class ThemeUpdate extends SharedPreferencesState {
  final bool isDark ;
  final String local ;
  final bool islogin ;
  ThemeUpdate( {required this.islogin, required this.isDark , required this.local});
}
