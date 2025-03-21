import 'package:chatapp/controller/sharedpref/shared_preferences_cubit.dart';
import 'package:chatapp/views/widgets/select_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLanguageButton extends StatelessWidget {
  const SelectLanguageButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SharedPreferencesCubit>();
    return Padding(
      padding: const EdgeInsets.only(
        left: 90,
        right: 90,
      ),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[70],
          ),
          onPressed: () {
            LanguageSelector.showLanguageSelector(context);
          },
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 8),
              BlocBuilder<SharedPreferencesCubit, SharedPreferencesState>(
                builder: (context, state) {
                  return Text(cubit.language);
                },
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_drop_down),
            ],
          )),
    );
  }
}
