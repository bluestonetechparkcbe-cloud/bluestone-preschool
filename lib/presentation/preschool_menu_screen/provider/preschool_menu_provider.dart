import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';

class PreschoolMenuProvider extends ChangeNotifier {
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

  void onLogoutPressed(BuildContext context) {
    // Navigate back to Login or Welcome
    Navigator.pushNamedAndRemoveUntil(
      context, 
      AppRoutes.preschoolLoginScreen, 
      (route) => false,
    );
  }
}
