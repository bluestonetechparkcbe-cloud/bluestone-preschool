import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../db_helper.dart';

class PreschoolMenuProvider extends ChangeNotifier {
  String studentName = "Student Name";
  // String studentImage = ""; // Placeholder if needed

  Future<void> loadMenuData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? email = prefs.getString('user_email');
      
      if (email != null) {
        final details = await DBHelper.getStudentBasicDetails(email);
        if (details != null && details['name'] != null) {
          studentName = details['name'];
        } else {
           // Fallback or keep default
           studentName = "Guest Student"; 
        }
      } else {
        studentName = "Guest";
      }
    } catch (e) {
      print("Error loading menu data: $e");
    }
    notifyListeners();
  }

  void onMenuItemTap(BuildContext context, String title) {
    // Placeholder for future navigation
    print("Menu Item Tapped: $title");
    
    // Switch case to handle different pages later
    switch (title) {
      case 'Updates':
        Navigator.pushNamed(context, AppRoutes.preschoolUpdatesScreen);
        break;
      case 'Rewards':
        Navigator.pushNamed(context, AppRoutes.rewardsScreen);
        break;
      case 'My Child’s Day':
         Navigator.pushNamed(context, AppRoutes.myChildsDayScreen); 
        break;
      case 'Teacher Notes':
        Navigator.pushNamed(context, AppRoutes.teacherNotesScreen);
        break;
      case 'Photo Gallery':
        Navigator.pushNamed(context, AppRoutes.photoGalleryScreen);
        break;
      case 'Pay Fees':
        Navigator.pushNamed(context, AppRoutes.payFeesScreen);
        break;
      case 'Parent Hub':
        Navigator.pushNamed(context, AppRoutes.parentHubScreen);
        break;
      case 'School Connect':
        Navigator.pushNamed(context, AppRoutes.schoolConnectScreen);
        break;
      // Add other cases here
    }
  }

  void onLogoutPressed(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // Navigate back to Login or Welcome
      Navigator.pushNamedAndRemoveUntil(
        context, 
        AppRoutes.preschoolLoginScreen, 
        (route) => false,
      );
    } catch (e) {
      print("Logout Error: $e");
    }
  }
}
