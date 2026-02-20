import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../db_helper.dart';

class MyChildsDayProvider extends ChangeNotifier {
  List<Map<String, dynamic>> activities = [];
  bool isLoading = false;
  DateTime selectedDate = DateTime.now();
  String? studentName;

  // Dropdown values
  int? selectedWeek;
  int? selectedDay;
  
  // Mode flag
  bool isDateMode = true;
  
  // Dummy themes
  final List<String> themes = [
    "Terrain Tales",
    "Ocean Odyssey",
    "Space Explorers",
    "Jungle Journey",
    "Dino Discovery",
    "Bug Life",
    "Weather Watchers",
    "Community Helpers"
  ];
  String currentTheme = "Terrain Tales";

  Future<void> loadActivities({DateTime? date}) async {
    isLoading = true;
    isDateMode = true;
    selectedWeek = null; // Clear dropdowns
    selectedDay = null;
    notifyListeners();

    if (date != null) {
      selectedDate = date;
    }

    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('user_email');

    if (email != null) {
       final studentDetails = await DBHelper.getStudentBasicDetails(email);
       if (studentDetails != null) {
         studentName = studentDetails['name'];
       }
       
       // Seed data for testing purposes
       await DBHelper.seedChildActivities(email);

      activities = await DBHelper.getActivitiesByDate(email, selectedDate);
    }
    
    isLoading = false;
    notifyListeners();
  }
  
  Future<void> loadActivitiesByWeekDay(int week, int day) async {
    isLoading = true;
    isDateMode = false;
    selectedWeek = week;
    selectedDay = day;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('user_email');
    
    if (email != null) {
       activities = await DBHelper.getActivitiesByWeekDay(email, week, day);
    }

    isLoading = false;
    notifyListeners();
  }

  void switchToToday() {
    selectedDate = DateTime.now();
    loadActivities(date: selectedDate);
  }
  
  void updateTheme(String theme) {
    currentTheme = theme;
    notifyListeners();
  }

  void onDateChanged(DateTime newDate) {
    loadActivities(date: newDate);
  }
}
