import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/preschool_profile_model.dart';

class PreschoolProfileProvider extends ChangeNotifier {
  PreschoolProfileModel preschoolProfileModelObj = PreschoolProfileModel();

  @override
  void dispose() {
    super.dispose();
  }
}
