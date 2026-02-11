import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/preschool_splash_model.dart';

class PreschoolSplashProvider extends ChangeNotifier {
  PreschoolSplashModel preschoolSplashModel = PreschoolSplashModel();

  void onGetStartedPressed(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.selectProgramScreen);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
