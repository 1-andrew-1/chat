import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'page_controller_state.dart';

class PageControllerCubit extends Cubit<PageControllerState> {
  final PageController pageController = PageController() ;
  PageControllerCubit() : super(PageControllerInitial());

  void onItemTapped(int page) {
    String title ;
    switch (page) {
      case 0:
        title = "Chats";
        break;
      case 1:
        title = "About screen";
        break;
      case 2:
        title = "Settings screen";
        break;
      default:
        title = "Home screen";
    }
    pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500), // **🔥 Smooth Transition Speed**
      curve: Curves.easeInOutExpo, // **🎢 Add a Beautiful Animation Curve**
    );
    emit(PageControllerSelect(index: page  , title: title)); // Update state properly
  }
}
