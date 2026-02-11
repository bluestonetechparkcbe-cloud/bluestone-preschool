import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../models/preschool_updates_model.dart';

class PreschoolUpdatesProvider extends ChangeNotifier {
  PreschoolUpdatesModel preschoolUpdatesModelObj = PreschoolUpdatesModel();
  
  // 0 for School Info, 1 for My Child's Day
  int _selectedTabIndex = 0;
  int get selectedTabIndex => _selectedTabIndex;

  void onTabChanged(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
