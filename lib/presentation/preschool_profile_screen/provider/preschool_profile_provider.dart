import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/preschool_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../db_helper.dart';

class PreschoolProfileProvider extends ChangeNotifier {
  PreschoolProfileModel preschoolProfileModelObj = PreschoolProfileModel();

  Future<void> loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('user_email');
      
      if (email != null) {
        final details = await DBHelper.getStudentProfileDetails(email);
        if (details != null) {
          preschoolProfileModelObj.studentName = details['name'] ?? "Unknown";
          preschoolProfileModelObj.uin = details['uin'] ?? "N/A";
          preschoolProfileModelObj.grade = details['grade'] ?? "N/A";
          preschoolProfileModelObj.gender = details['gender'] ?? "N/A";
          preschoolProfileModelObj.fatherName = details['father_name'] ?? "N/A";
          preschoolProfileModelObj.fatherEmail = details['father_email'] ?? "N/A";
          preschoolProfileModelObj.fatherPhone = details['father_phone'] ?? "N/A";
          preschoolProfileModelObj.motherName = details['mother_name'] ?? "N/A";
          preschoolProfileModelObj.motherEmail = details['mother_email'] ?? "N/A";
          preschoolProfileModelObj.motherPhone = details['mother_phone'] ?? "N/A";
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error loading profile data: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
