import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';

class PreschoolLoginProvider extends ChangeNotifier {
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  void onGetOTPPressed(BuildContext context) {
    // Implement OTP logic or navigation
    // For now, maybe navigate to an OTP verification screen or home
    Navigator.pushNamed(context, AppRoutes.preschoolOtpScreen); 
    print("Get OTP Pressed with number: ${phoneNumberController.text}");
  }

  void onLoginAsEducatorPressed(BuildContext context) {
    // Navigate to Educator Login
    // Navigator.pushNamed(context, AppRoutes.educatorLoginScreen);
    print("Login as Educator Pressed");
  }
}
