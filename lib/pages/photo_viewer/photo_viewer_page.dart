import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoViewerPage extends StatelessWidget {
  const PhotoViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final photoPath = args?['photoPath'] ?? '';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: photoPath.isEmpty
            ? const Icon(Icons.image_not_supported, color: Colors.white54, size: 64)
            : InteractiveViewer(
                minScale: 0.5,
                maxScale: 5.0,
                child: Image.file(File(photoPath), fit: BoxFit.contain),
              ),
      ),
    );
  }
}
