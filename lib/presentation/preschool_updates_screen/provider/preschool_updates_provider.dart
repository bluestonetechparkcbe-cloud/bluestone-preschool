import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/preschool_updates_model.dart';
import '../../../../db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class PreschoolUpdatesProvider extends ChangeNotifier {
  PreschoolUpdatesModel preschoolUpdatesModelObj = PreschoolUpdatesModel();
  
  List<Map<String, dynamic>> schoolUpdates = [];
  List<Map<String, dynamic>> studentLogs = [];
  String? studentName;
  bool isLoading = false;

  // 0 for School Info, 1 for My Child's Day
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void onTabChanged(int index) {
    _selectedTabIndex = index;
    notifyListeners();
    if (index == 0 && schoolUpdates.isEmpty) {
      loadSchoolUpdates();
    } else if (index == 1 && studentLogs.isEmpty) {
      loadStudentLogs();
    }
  }

  Future<void> loadSchoolUpdates() async {
    isLoading = true;
    notifyListeners();
    
    schoolUpdates = await DBHelper.getSchoolUpdates();
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadStudentLogs() async {
    isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('user_email');
    print("Provider: Fetched email from prefs: $email");
    
    if (email != null) {
      // Fetch student details to get the name
      final studentDetails = await DBHelper.getStudentBasicDetails(email);
      if (studentDetails != null) {
        studentName = studentDetails['name'];
      }
      
      studentLogs = await DBHelper.getStudentLogs(email);
      print("Provider: Loaded ${studentLogs.length} logs");
    } else {
      print("Provider: No email found in SharedPreferences");
    }
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> onOpenLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  void onShare(String text, {String? subject}) {
    Share.share(text, subject: subject);
  }

  void shareStudentLog(Map<String, dynamic> log) {
    final String dateStr = log['date'] != null 
        ? "${log['date'].day}/${log['date'].month}/${log['date'].year}" 
        : "N/A";
        
    final String message = 
      "*MyDay@Bluestone Update for $dateStr*\n\n"
      "*Activity:* ${log['title']}\n"
      "*Details:* ${log['description']}\n\n"
      "Thank you for being part of the Bluestone Preschool family!";
      
    final String subject = "Daily Update for ${studentName ?? 'Your Child'}";
    
    Share.share(message, subject: subject);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
