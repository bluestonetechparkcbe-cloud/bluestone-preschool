import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class SelectProgramProvider extends ChangeNotifier {
  void onProgramSelected(BuildContext context, String programName) {
    // Handle program selection
    // For now, maybe just print or navigate to next logical step (e.g., Login)
    // Navigator.pushNamed(context, AppRoutes.loginScreen);
  }

  void onProceedToLogin(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.preschoolLoginScreen); 
  }
}
