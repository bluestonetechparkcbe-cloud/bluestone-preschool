import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../db_helper.dart';
import '../../preschool_otp_screen/preschool_otp_screen.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../../../../core/config/email_config.dart';

class PreschoolLoginProvider extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void onGetOTPPressed(BuildContext context, int programId) async {
    String email = emailController.text.trim();
    if (email.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter valid email address")));
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Generate 4 digit OTP
    String otp = (1000 + DateTime.now().millisecondsSinceEpoch % 9000).toString();

    // Send Email
    final smtpServer = gmail(EmailConfig.senderEmail, EmailConfig.appPassword);
    final message = Message()
      ..from = Address(EmailConfig.senderEmail, 'Bluestone Preschool')
      ..recipients.add(email)
      ..subject = 'Your Login OTP'
      ..text = 'Your OTP for Bluestone Preschool login is: $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      
      // Call DB Helper (Update to use email)
      await DBHelper.registerUser(email, programId);

      _isLoading = false;
      notifyListeners();

      // Navigate to OTP
      Navigator.pushNamed(
        context,
        AppRoutes.preschoolOtpScreen,
        arguments: {'email': email, 'otp': otp},
      );
    } catch (e) {
      print('Message not sent. \n' + e.toString());
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to send OTP. Try again.")));
    }
  }

  void onLoginAsEducatorPressed(BuildContext context) {
    // Navigate to Educator Login
    // Navigator.pushNamed(context, AppRoutes.educatorLoginScreen);
    print("Login as Educator Pressed");
  }
}
