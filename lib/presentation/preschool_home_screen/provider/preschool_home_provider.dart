import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../db_helper.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../../core/config/email_config.dart';

class PreschoolHomeProvider extends ChangeNotifier {
  // ... existing fields ...
  bool _isVerified = false;
  bool _isLoading = true;
  double _studentProgress = 0.0;
  String? _currentUserEmail;
  String? _studentName;
  int? _currentParentId; // Store User ID

  bool get isVerified => _isVerified;
  bool get isLoading => _isLoading;
  double get studentProgress => _studentProgress;
  String? get studentName => _studentName;

  // Initialize with email
  Future<void> init(String email) async {
    _currentUserEmail = email;
    _isLoading = true;
    notifyListeners();

    // Fetch Parent ID first
    _currentParentId = await DBHelper.getUserId(email);

    await checkVerificationStatus();
    if (_isVerified) {
      await loadStudentProgress();
    }
    // Always load student name if possible (even if pending)
    await loadStudentName();

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

  Future<void> loadStudentName() async {
    if (_currentUserEmail == null) return;
    final details = await DBHelper.getStudentBasicDetails(_currentUserEmail!);
    if (details != null) {
      _studentName = details['name'];
    }
    notifyListeners();
  }

  Future<bool> addNewStudent(String name, DateTime dob, String gender) async {
    if (_currentParentId == null) return false;
    
    // Pass ID instead of email
    bool success = await DBHelper.addStudent(_currentParentId!, name, dob, gender);
    if (success) {
      _studentName = name; // Immediate UI update
      
      // Send Enrollment Alert
      try {
          final smtpServer = gmail(EmailConfig.senderEmail, EmailConfig.appPassword);
          String dobStr = "${dob.toLocal()}".split(' ')[0];
          
          final message = Message()
            ..from = Address(EmailConfig.senderEmail, 'Bluestone Preschool')
            ..recipients.add(EmailConfig.senderEmail) // Send to Admin
            ..subject = 'New Student Enrollment'
            ..text = 'New Student Enrollment:\nName: $name\nDOB: $dobStr\nGender: $gender\nParent ID: $_currentParentId';
          
          await send(message, smtpServer);
          print("Enrollment Alert Sent");
      } catch (e) {
          print("Failed to send enrollment alert: $e");
      }

      await checkVerificationStatus(); // Status might have changed to 'Pending'
      notifyListeners();
    }
    return success;
  }

  void onParentCornerPressed(BuildContext context) {
    // If student added (and verified?), navigate to menu. 
    // Logic said "If provider.studentName is not null... keep lock icon visible".
    // Usually Parent Corner opens menu. Current logic: if verified -> open, else -> locked sheet.
    // I will keep existing logic for navigation but UI will change label.
    Navigator.pushNamed(context, AppRoutes.preschoolMenuScreen);
  }
  
  // Logout Helper logic could be here but UI handles navigation usually.
}
