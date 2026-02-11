import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/welcome_model.dart';

class WelcomeProvider extends ChangeNotifier {
  WelcomeModel welcomeModel = WelcomeModel();

  @override
  void dispose() {
    super.dispose();
  }

  void onGetStartedPressed(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.servicesHomeScreen);
  }
}
