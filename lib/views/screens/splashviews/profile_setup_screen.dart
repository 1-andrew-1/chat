import 'dart:io';
import 'package:chatapp/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// handle this page 
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 350,
              ),
              const Icon(Icons.chat_bubble_outline,
                  size: 40, color: Colors.purple),
              const SizedBox(height: 10),
              Text(
                S.of(context).ProfileSetupScreen_text,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 40),

              // Profile Image Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).ProfileSetupScreen_text,
                  style: TextStyle(
                      color: Colors.purple.shade300,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 7),

              // Profile Image Container
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                        color: Colors.grey.shade200,
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!), fit: BoxFit.cover)
                            : const DecorationImage(
                                image: AssetImage("assets/images/AVA.jpeg"),
                                fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: _pickImage,
                    child:  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        S.of(context).ProfileSetupScreen_text_button,
                        style: const TextStyle(fontSize: 12, color: Colors.purple),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    S.of(context).ProfileSetupScreenfirst_name_text,
                    style: TextStyle(
                        color: Colors.purple.shade300,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 130),
                  Text(
                    S.of(context).ProfileSetupScreenlast_name_text,
                    style: TextStyle(
                        color: Colors.purple.shade300,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              // Name Fields
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Jane",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Doe",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Complete Setup Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child:  Text(S.of(context).ProfileSetupScreen_text_button,
                      style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
