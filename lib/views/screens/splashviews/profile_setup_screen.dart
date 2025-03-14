import 'dart:io';
import 'dart:typed_data';
import 'package:chatapp/controller/users%20status/chat_contact_cubit.dart';
import 'package:chatapp/core/constants/constants.dart';
import 'package:chatapp/generated/l10n.dart';
import 'package:chatapp/views/screens/home/homeseceen.dart';
import 'package:chatapp/views/widgets/custom_page_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  File? _image;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  // اختيار صورة من المعرض
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // حفظ الصورة الافتراضية مؤقتًا في التخزين المحلي
  Future<File> _saveTempImage(List<int> bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/default_profile.jpg");
    await file.writeAsBytes(bytes);
    return file;
  }

  // رفع الصورة إلى Firebase Storage
  Future<String?> _uploadImage(File? image) async {
    try {
      if (image == null) {
        // تحميل الصورة الافتراضية إذا لم يتم اختيار صورة
        ByteData data = await rootBundle.load("assets/images/OIP (4).jpeg");
        List<int> bytes = data.buffer.asUint8List();
        image = await _saveTempImage(bytes);
      }

      String fileName = "profile_pics/${Constants.userID}.jpg";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // حفظ بيانات المستخدم في Firestore
  Future<void> _saveUserData() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // تحميل الصورة سواء كانت مختارة أو افتراضية
      String? imageUrl = await _uploadImage(_image);

      DocumentReference userRef =
          FirebaseFirestore.instance.collection("users").doc(Constants.userID);

      await userRef.set(
        {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'profile_image': imageUrl ?? "",
        },
        SetOptions(merge: true),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile setup completed!")),
      );

      // الانتقال إلى الشاشة الرئيسية بعد حفظ البيانات
      navigateOffAll(
        context,
        BlocProvider(
          create: (context) => ChatContactCubit(),
          child: const HomeScreen(),
        ));
    } catch (e) {
      print("Error saving user data: $e");
    } finally {
      setState(() {
        _isUploading = false;
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
              const SizedBox(height: 350),
              const Icon(Icons.chat_bubble_outline,
                  size: 40, color: Colors.purple),
              const SizedBox(height: 10),
              Text(
                S.of(context).ProfileSetupScreen_text,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
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
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade200,
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image!), fit: BoxFit.cover)
                            : const DecorationImage(
                                image: AssetImage("assets/images/OIP (4).jpeg"),
                                fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        S.of(context).ProfileSetupScreen_text1,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.purple),
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
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        hintText: "First Name",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        hintText: "Last Name",
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
                  onPressed: _isUploading ? null : _saveUserData,
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(S.of(context).ProfileSetupScreen_text_button,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
