import 'package:chatapp/controller/cubit_unsing/pages/page_controller_cubit.dart';
import 'package:chatapp/views/widgets/sizeconig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottonNavigationBar extends StatelessWidget {
  const BottonNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(SizeConfig.defaultSize * 1.2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withOpacity(0.2) // لون للـ Dark Mode
                  : Colors.black.withOpacity(0.4), // لون للـ Light Mode
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
          child: BlocBuilder<PageControllerCubit, PageControllerState>(
            builder: (context, state) {
              int index = 0;
              if (state is PageControllerSelect) {
                index = state.index;
              }

              return BottomNavigationBar(
                onTap: (page) {
                  context.read<PageControllerCubit>().onItemTapped(page);
                },
                currentIndex: index,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: const Color(0xFF7C01F6),
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                items: items,
              );
            },
          ),
        ));
  }
}

var items = [
  BottomNavigationBarItem(
    icon: Image.asset("assets/images/chat.png", height: 30, color: Colors.grey),
    activeIcon: Image.asset("assets/images/chat.png",
        height: 30, color: Color(0xFF7C01F6)),
    label: 'Chat',
  ),
  BottomNavigationBarItem(
    icon: Image.asset("assets/images/call.png", height: 30, color: Colors.grey),
    activeIcon: Image.asset("assets/images/call.png",
        height: 30, color: Color(0xFF7C01F6)),
    label: 'Calls',
  ),
  BottomNavigationBarItem(
    icon:
        Image.asset("assets/images/Camera.png", height: 30, color: Colors.grey),
    activeIcon: Image.asset("assets/images/Camera.png",
        height: 30, color: Color(0xFF7C01F6)),
    label: 'Camera',
  ),
  BottomNavigationBarItem(
    icon: Image.asset("assets/images/Setting.png",
        height: 30, color: Colors.grey),
    activeIcon: Image.asset("assets/images/Setting.png",
        height: 30, color: Color(0xFF7C01F6)),
    label: 'Settings',
  ),
];
