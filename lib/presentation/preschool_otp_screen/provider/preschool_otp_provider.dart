import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';

class PreschoolOtpProvider extends ChangeNotifier {
  List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());
  
  Timer? _timer;
  int _secondsRemaining = 17;
  int get secondsRemaining => _secondsRemaining;
  bool get isResendEnabled => _secondsRemaining == 0;

  PreschoolOtpProvider() {
    startTimer();
  }

  void startTimer() {
    _secondsRemaining = 17;
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
        // Auto-submit or verify could happen here
      }
    } else {
      if (index > 0) {
        FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      }
    }
  }

  void onConfirmPressed(BuildContext context) {
    String otp = otpControllers.map((e) => e.text).join();
    print("OTP Entered: $otp");
    // Navigate to Home Screen
    Navigator.pushNamed(context, AppRoutes.preschoolHomeScreen);
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
