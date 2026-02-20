import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

class PreschoolGalleryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> allPhotos = [];
  List<Map<String, dynamic>> displayedPhotos = [];
  bool isLoading = false;
  bool isAllPhotosSelected = true;
  String? studentName;

  Future<void> loadPhotos() async {
    isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('user_email');
    
    if (email != null) {
      // Fetch student details for share subject
      final studentDetails = await DBHelper.getStudentBasicDetails(email);
      if (studentDetails != null) {
        studentName = studentDetails['name'];
      }

      allPhotos = await DBHelper.getGalleryPhotos(email);
      _applyFilter();
    }
    
    isLoading = false;
    notifyListeners();
  }

  void toggleFilter(bool isAll) {
    isAllPhotosSelected = isAll;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (isAllPhotosSelected) {
      displayedPhotos = List.from(allPhotos);
    } else {
      // Filter for specific child photos (where student_id is NOT null)
      displayedPhotos = allPhotos.where((photo) => photo['student_id'] != null).toList();
    }
  }

  Future<void> saveImageToDevice(String path, BuildContext context) async {
    try {
      // Gal handles permissions internally for the most part, but we can request if needed.
      if (!await Gal.hasAccess()) {
        await Gal.requestAccess();
      }
      
      Uint8List? imageBytes;

      if (path.startsWith('http') || path.startsWith('https')) {
        // Network Image
        final response = await http.get(Uri.parse(path));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
        } else {
           if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to download image.")));
           return;
        }
      } else if (path.startsWith('assets/')) {
        // Asset Image
        final byteData = await rootBundle.load(path);
        imageBytes = byteData.buffer.asUint8List();
      } else {
        // Local File
        final file = File(path);
        if (await file.exists()) {
          imageBytes = await file.readAsBytes();
        }
      }

      if (imageBytes != null) {
        await Gal.putImageBytes(
          imageBytes,
          name: "Bluestone_Photo_${DateTime.now().millisecondsSinceEpoch}",
        );
        
        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Photo saved to Gallery!")), 
           );
        }
      } else {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image source not found.")));
      }
    } catch (e) {
      print("Save Image Error: $e");
      String errorMessage = "Error saving photo.";
      if (e is GalException) {
         errorMessage = "Gallery Error: ${e.type}";
      }
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
