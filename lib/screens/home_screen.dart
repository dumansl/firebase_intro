import 'dart:io';

import 'package:firebase_intro/widget/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_intro/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService authService = AuthService();
  XFile? selectedImage;
  String avatarUrl = "";

  void _pickImage() async {
    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        selectedImage = file;
      });

      try {
        // Resim seçildiğinde avatarUrl'i "abc" olarak atama işlemi
        setState(() {
          avatarUrl = "abc";
        });
      } catch (e) {
        debugPrint("AvatarUrl atama hatası: $e");
      }
    }
  }

  void _addedAvatarUrl() async {
    if (selectedImage != null) {
      try {
        await authService.addedAvatarUrl(avatarUrl: avatarUrl);
        if (mounted) {
          snackBar(context, "Avatar URL güncellendi: $avatarUrl",
              bgColor: Colors.green);
        }
      } catch (e) {
        if (mounted) {
          snackBar(
            context,
            "Avatar URL güncelleme hatası: $e",
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _pickImage,
                child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: selectedImage != null
                        ? Image.file(File(selectedImage!.path)).image
                        : null,
                    child: selectedImage == null
                        ? const Icon(Icons.add_a_photo, size: 40)
                        : null),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _addedAvatarUrl,
                child: const Text("Güncelle"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
