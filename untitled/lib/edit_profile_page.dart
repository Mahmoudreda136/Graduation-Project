import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'globals.dart'; // استيراد المتغيرات العامة لتحديث البريد الإلكتروني

class EditProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userImage;

  const EditProfilePage({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.userImage,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late String userImage;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userName);
    emailController = TextEditingController(text: widget.userEmail);
    userImage = widget.userImage;
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image. Please try again.")),
      );
    }
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void _saveProfile() {
    String updatedName = nameController.text.trim();
    String updatedEmail = emailController.text.trim();

    if (updatedName.isEmpty || updatedEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Name and Email cannot be empty")),
      );
      return;
    }

    if (!_isValidEmail(updatedEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid email address")),
      );
      return;
    }

    // تحديث المتغيرات العامة
    registeredName = updatedName;
    registeredEmail = updatedEmail;
    registeredPassword = registeredPassword; // يحتفظ بكلمة المرور كما هي

    // إرجاع البيانات إلى الصفحة السابقة (اختياري)
    Navigator.pop(context, {
      'name': updatedName,
      'email': updatedEmail,
      'image': _imageFile != null ? _imageFile!.path : userImage,
    });

    // عرض رسالة نجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Edit Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (userImage.isNotEmpty
                        ? (userImage.startsWith('/')
                        ? FileImage(File(userImage))
                        : AssetImage(userImage)) as ImageProvider
                        : AssetImage('assets/placeholder.jpg')),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.brown,
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}