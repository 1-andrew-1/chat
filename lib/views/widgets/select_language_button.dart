import 'package:chatapp/controller/sharedpref/shared_preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectLanguageButton extends StatelessWidget {
  const SelectLanguageButton({super.key});

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Language",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                _buildLanguageItem(context, "English", "en"),
                _buildLanguageItem(context, "العربية", "ar"),
                _buildLanguageItem(context, "Français", "fr"),
                _buildLanguageItem(context, "Español", "es"),
                _buildLanguageItem(context, "Deutsch", "de"),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(BuildContext context, String name, String code) {
    final cubit = context.read<SharedPreferencesCubit>();
    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(name),
      onTap: () {
        cubit.changeLocal(code);
        cubit.language = name;
        Navigator.pop(context); // إغلاق القائمة عند الاختيار
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selected Language: $name ($code)")),
        );
      },
    );
  }

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
          onPressed: () => _showLanguageSelector(context),
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
