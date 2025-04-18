import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  
  Future<String?> pickImage({required bool fromCamera}) async {
    try {
      // Pick an image
      final XFile? pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile == null) {
        return null;
      }
      
      // Get application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(pickedFile.path);
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String savedFileName = '${timestamp}_$fileName';
      final String savedFilePath = path.join(appDir.path, savedFileName);
      
      // Copy the picked image to the application documents directory
      final File savedFile = await File(pickedFile.path).copy(savedFilePath);
      
      return savedFile.path;
    } catch (e) {
      debugPrint('Error picking image: $e');
      rethrow;
    }
  }
} 