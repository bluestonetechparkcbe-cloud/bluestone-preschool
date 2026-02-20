import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class TeacherNoteDetailScreen extends StatelessWidget {
  final Map<String, dynamic> note;

  const TeacherNoteDetailScreen({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Teacher Note",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20.fSize, color: Colors.black)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              note['title'] ?? "",
              style: TextStyle(
                fontSize: 22.fSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.v),
            // Date
            Text(
              note['date']?.toString().split(' ')[0] ?? "",
              style: TextStyle(
                fontSize: 14.fSize,
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.v),

            // Large Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16.h),
              child: CustomImageView(
                imagePath: note['detail_image_path'] ?? note['illustration_path'] ?? ImageConstant.imgGrowingIndependence,
                height: 200.adaptSize,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            
            SizedBox(height: 24.v),
            
            // Full Note
            Text(
              note['full_note'] ?? note['summary'] ?? "",
              style: TextStyle(
                fontSize: 16.fSize,
                fontFamily: 'Poppins',
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
