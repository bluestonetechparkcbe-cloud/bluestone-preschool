import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../preschool_login_screen/preschool_login_screen.dart';

class SelectProgramProvider extends ChangeNotifier {
  int? selectedProgramId;

  void onProgramSelected(int id) {
    selectedProgramId = id;
    notifyListeners();
  }

  void onProceedToLogin(BuildContext context) {
    if (selectedProgramId != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.preschoolLoginScreen,
        arguments: selectedProgramId,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a program first")),
      );
    }
  }
}
