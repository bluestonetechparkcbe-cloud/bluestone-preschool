import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/school_connect_model.dart';

class SchoolConnectProvider extends ChangeNotifier {
  SchoolConnectModel schoolConnectModel = SchoolConnectModel();

  @override
  void dispose() {
    super.dispose();
  }
}
