import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';

class PreschoolHomeProvider extends ChangeNotifier {
  void onParentCornerPressed(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.preschoolMenuScreen);
  }
}
