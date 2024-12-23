import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImagesPage extends StatefulWidget {
  final Function(List<Uint8List>) onImagesUploaded;

  UploadImagesPage({required this.onImagesUploaded});

  @override
  _UploadImagesPageState createState() => _UploadImagesPageState();
}

class _UploadImagesPageState extends State<UploadImagesPage> {
  final ImagePicker _picker = ImagePicker();
  List<Uint8List> _uploadedImages = [];

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      for (var image in images) {
        final bytes = await image.readAsBytes(); // استخدام readAsBytes
        setState(() {
          _uploadedImages.add(bytes); // إضافة الصور إلى القائمة
        });
      }
    }
  }

  void _onDone() {
    if (_uploadedImages.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("You must upload at least 5 images."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    widget.onImagesUploaded(_uploadedImages);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Images"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _uploadedImages.isEmpty
                  ? Center(
                child: Text(
                  "No images uploaded yet.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _uploadedImages.length,
                itemBuilder: (context, index) {
                  return Image.memory(
                    _uploadedImages[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _pickImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text("Upload Images"),
                ),
                ElevatedButton(
                  onPressed: _onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text("Done"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}