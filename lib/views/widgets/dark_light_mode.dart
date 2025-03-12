import 'package:chatapp/controller/sharedpref/shared_preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DarkLightMode extends StatelessWidget {
  const DarkLightMode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedPreferencesCubit, SharedPreferencesState>(
            builder: (context, themeMode) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: IconButton(
                  key: ValueKey(themeMode),
                  icon: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                  onPressed: () {
                    context.read<SharedPreferencesCubit>().changeTheme();
                  },
                ),
              );
            },
          );
  }
}