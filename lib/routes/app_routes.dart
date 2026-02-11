import 'package:flutter/material.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/services_home_screen/services_home_screen.dart';
import '../presentation/app_navigation_screen/app_navigation_screen.dart';
import '../presentation/preschool_splash_screen/preschool_splash_screen.dart';
import '../presentation/select_program_screen/select_program_screen.dart';
import '../presentation/preschool_login_screen/preschool_login_screen.dart';
import '../presentation/preschool_otp_screen/preschool_otp_screen.dart';
import '../presentation/preschool_home_screen/preschool_home_screen.dart';
import '../presentation/preschool_menu_screen/preschool_menu_screen.dart';
import '../presentation/preschool_profile_screen/preschool_profile_screen.dart';
import '../presentation/preschool_updates_screen/preschool_updates_screen.dart';
import '../presentation/photo_gallery_screen/photo_gallery_screen.dart';
import '../presentation/my_childs_day_screen/my_childs_day_screen.dart';
import '../presentation/teacher_notes_screen/teacher_notes_screen.dart';
import '../presentation/parent_hub_screen/parent_hub_screen.dart';
import '../presentation/rewards_screen/rewards_screen.dart';
import '../presentation/pay_fees_screen/pay_fees_screen.dart';
import '../presentation/school_connect_screen/school_connect_screen.dart';

class AppRoutes {
  static const String welcomeScreen = '/welcome_screen';
  static const String servicesHomeScreen = '/services_home_screen';
  static const String preschoolSplashScreen = '/preschool_splash_screen';
  static const String selectProgramScreen = '/select_program_screen';
  static const String preschoolLoginScreen = '/preschool_login_screen';
  static const String preschoolOtpScreen = '/preschool_otp_screen';
  static const String preschoolHomeScreen = '/preschool_home_screen';
  static const String preschoolMenuScreen = '/preschool_menu_screen';
  static const String preschoolProfileScreen = '/preschool_profile_screen';
  static const String preschoolUpdatesScreen = '/preschool_updates_screen';
  static const String photoGalleryScreen = '/photo_gallery_screen';
  static const String myChildsDayScreen = '/my_childs_day_screen';
  static const String teacherNotesScreen = '/teacher_notes_screen';
  static const String parentHubScreen = '/parent_hub_screen';
  static const String rewardsScreen = '/rewards_screen';
  static const String payFeesScreen = '/pay_fees_screen';
  static const String schoolConnectScreen = '/school_connect_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  
  // Changed initial route as per user request to start from App Navigation Screen (or restore to normal flow later)
  static const String initialRoute = '/initialRoute'; 

  static Map<String, WidgetBuilder> get routes => {
    welcomeScreen: WelcomeScreen.builder,
    servicesHomeScreen: ServicesHomeScreen.builder,
    preschoolSplashScreen: PreschoolSplashScreen.builder,
    selectProgramScreen: SelectProgramScreen.builder,
    preschoolLoginScreen: PreschoolLoginScreen.builder,
    preschoolOtpScreen: PreschoolOtpScreen.builder,
    preschoolHomeScreen: PreschoolHomeScreen.builder,
    preschoolMenuScreen: PreschoolMenuScreen.builder,
    preschoolProfileScreen: PreschoolProfileScreen.builder,
    preschoolUpdatesScreen: PreschoolUpdatesScreen.builder,
    photoGalleryScreen: (context) => const PhotoGalleryScreen(),
    myChildsDayScreen: (context) => const MyChildsDayScreen(),
    teacherNotesScreen: (context) => const TeacherNotesScreen(),
    parentHubScreen: ParentHubScreen.builder,
    rewardsScreen: RewardsScreen.builder,
    payFeesScreen: PayFeesScreen.builder,
    schoolConnectScreen: SchoolConnectScreen.builder,
    appNavigationScreen: AppNavigationScreen.builder,
    initialRoute: WelcomeScreen.builder,
  };
}
