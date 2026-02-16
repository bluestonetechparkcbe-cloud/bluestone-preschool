import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../db_helper.dart';

class PreschoolHomeProvider extends ChangeNotifier {
  bool _isVerified = false;
  bool _isLoading = true;
  double _studentProgress = 0.0;
  String? _currentUserEmail;

  bool get isVerified => _isVerified;
  bool get isLoading => _isLoading;
  double get studentProgress => _studentProgress;

  // Initialize with email
  Future<void> init(String email) async {
    _currentUserEmail = email;
    _isLoading = true;
    notifyListeners();

    await checkVerificationStatus();
    if (_isVerified) {
      await loadStudentProgress();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkVerificationStatus() async {
    if (_currentUserEmail == null) return;
    _isVerified = await DBHelper.getVerificationStatus(_currentUserEmail!);
    notifyListeners();
  }

  Future<void> loadStudentProgress() async {
    if (_currentUserEmail == null) return;
    _studentProgress = await DBHelper.getStudentProgress(_currentUserEmail!);
    notifyListeners();
  }

  Future<bool> addNewStudent(String name, DateTime dob, String gender) async {
    if (_currentUserEmail == null) return false;
    
    bool success = await DBHelper.addStudent(_currentUserEmail!, name, dob, gender);
    if (success) {
      // If adding student implies they might become verified or just data update
      // For now, user didn't say adding student AUTO-verifies, but usually it might.
      // I'll re-check verification status just in case backend changes it.
      await checkVerificationStatus();
    }
    return success;
  }

  void onParentCornerPressed(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.preschoolMenuScreen);
  }
}
