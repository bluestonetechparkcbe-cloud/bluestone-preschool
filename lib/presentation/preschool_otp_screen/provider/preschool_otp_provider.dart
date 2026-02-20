import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/app_export.dart';
import '../../../../core/config/email_config.dart';
import '../../../../db_helper.dart';

class PreschoolOtpProvider extends ChangeNotifier {
  List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  
  Timer? _timer;
  int _secondsRemaining = 120;
  int get secondsRemaining => _secondsRemaining;
  bool get isResendEnabled => _secondsRemaining == 0;

  PreschoolOtpProvider() {
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 120;
    notifyListeners();
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        notifyListeners();
      } else {
        _timer?.cancel();
      }
    });
  }

  void onOtpChanged(BuildContext context, int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  void onConfirmPressed(BuildContext context, Map<String, dynamic> args) async {
    String enteredOtp = otpControllers.map((e) => e.text).join();
    if (enteredOtp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter complete OTP")));
      return;
    }
    
    String generatedOtp = args['otp'];
    String email = args['email'];

    if (enteredOtp == generatedOtp) {
      print("OTP Verified");
       // Verify user in DB
      bool exists = await DBHelper.verifyUser(email);
      
      if (exists) {
        // Send Registration Alert
        try {
          final smtpServer = gmail(EmailConfig.senderEmail, EmailConfig.appPassword);
          final message = Message()
            ..from = Address(EmailConfig.senderEmail, 'Bluestone Preschool')
            ..recipients.add(EmailConfig.senderEmail) // Send to Admin
            ..subject = 'New Parent Registered'
            ..text = 'New Parent Registered: $email';
          
          await send(message, smtpServer);
          print("Registration Alert Sent");
        } catch (e) {
          print("Failed to send registration alert: $e");
        }

        // Save Session
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_email', email);
        } catch (e) {
          print("Failed to save session: $e");
        }

        // Navigate to Home Screen
        Navigator.pushNamedAndRemoveUntil(
          context, 
          AppRoutes.preschoolHomeScreen,
          (route) => false,
          arguments: {'email': email},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Verification failed. User not found.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid OTP")));
    }
  }

  void onResendPressed() {
    if (isResendEnabled) {
      startTimer();
      print("Resend code requested");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
