
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'uichanger_state.dart';

class UichangerCubit extends Cubit<UichangerState> {
  UichangerCubit() : super(UichangerInitial());
}
