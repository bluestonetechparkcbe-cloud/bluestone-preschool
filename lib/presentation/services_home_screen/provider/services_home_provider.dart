import 'package:flutter/material.dart';
import '../models/services_home_model.dart';
import '../../../core/app_export.dart';

class ServicesHomeProvider extends ChangeNotifier {
  ServicesHomeModel servicesHomeModel = ServicesHomeModel();

  @override
  void dispose() {
    super.dispose();
  }

  void initialize() {
    // Initialize any required data
    notifyListeners();
  }

  void onProfileTap() {
    // Handle profile icon tap
    // Navigate to profile screen or show profile options

    notifyListeners();
  }

  void onNotificationTap() {
    // Handle notification icon tap
    // Navigate to notifications screen or show notification panel

    notifyListeners();
  }

  void onServiceTap(String serviceType) {
    // Handle service card tap based on service type
    switch (serviceType) {
      case 'overseas':
        _handleOverseasService();
        break;
      case 'ias_academy':
        _handleIASAcademyService();
        break;
      case 'placements':
        _handlePlacementsService();
        break;
      case 'elite_sports':
        _handleEliteSportsService();
        break;
      case 'tech_park':
        _handleTechParkService();
        break;
      case 'language_hub':
        _handleLanguageHubService();
        break;
      case 'preschool':
        _handlePreschoolService();
        break;
      case 'startup':
        _handleStartupService();
        break;
      case 'fun_zone':
        _handleFunZoneService();
        break;
      default:

    }
    notifyListeners();
  }

  void _handleOverseasService() {
    // Navigate to overseas services

  }

  void _handleIASAcademyService() {
    // Navigate to IAS Academy

  }

  void _handlePlacementsService() {
    // Navigate to placement services
    // User requested: 1st row last card (3rd card) -> Preschool Flow
    // ONLY this card should be active as per latest request
    Navigator.pushNamed(NavigatorService.navigatorKey.currentContext!, AppRoutes.preschoolSplashScreen);
  }

  void _handleEliteSportsService() {
    // Navigate to elite sports

  }

  void _handleTechParkService() {
    // Navigate to tech park

  }

  void _handleLanguageHubService() {
    // Navigate to language hub

  }

  void _handlePreschoolService() {
    // Navigate to preschool services 
    // Disabled as per request "only third is clickable"
    // Navigator.pushNamed(NavigatorService.navigatorKey.currentContext!, AppRoutes.preschoolSplashScreen);
  }

  void _handleStartupService() {
    // Navigate to startup services

  }

  void _handleFunZoneService() {
    // Navigate to fun zone

  }
}
