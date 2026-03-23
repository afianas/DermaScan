import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'result_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  // 📸 Open Camera
  Future<void> openCamera() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      selectedImage = File(image.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(image: selectedImage!),
        ),
      );
    }
  }

  // 🖼 Open Gallery
  Future<void> openGallery() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedImage = File(image.path);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(image: selectedImage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: boxStyle(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Capture Your Face",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: boxStyle(),
                        child: const Icon(Icons.close, size: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Preview
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: boxStyle(color: const Color(0xFFAED4E6)),
                  child: selectedImage == null
                      ? const Center(child: Text("No Image Selected"))
                      : Image.file(selectedImage!, fit: BoxFit.cover),
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: openCamera,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: boxStyle(color: const Color(0xFF7EC8E3)),
                          child: const Center(child: Text("Start Camera")),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: openGallery,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: boxStyle(),
                          child: const Center(child: Text("Upload Image")),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: boxStyle(color: const Color(0xFFD6DEE8)),
                  child: const Text(
                    "Ensure your face is well-lit and clearly visible",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

BoxDecoration boxStyle({Color color = Colors.white}) {
  return BoxDecoration(
    color: color,
    border: Border.all(
      color: const Color(0xFF2D3748),
      width: 2,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFF2D3748),
        offset: Offset(4, 4),
        blurRadius: 0,
      ),
    ],
  );
}
}