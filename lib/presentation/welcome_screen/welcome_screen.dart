import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/custom_image_view.dart';
import './provider/welcome_provider.dart';
import '../../db_helper.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider<WelcomeProvider>(
      create: (context) => WelcomeProvider(),
      child: WelcomeScreen(),
    );
  }

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');

      if (email != null) {
        // Log detected
        print("LOG: Auto-login detected for $email");

        // Sync Status
        bool isVerified = await DBHelper.getVerificationStatus(email);
        print("LOG: Verification Status: $isVerified");

        if (mounted) {
           Navigator.pushNamedAndRemoveUntil(
             context, 
             AppRoutes.preschoolHomeScreen, 
             (route) => false,
             arguments: {'email': email},
           );
           return;
        }
      }
    } catch (e) {
      print("Auto-login error: $e");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Consumer<WelcomeProvider>(
            builder: (context, provider, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF2D7A),
                                appTheme.pink_500,
                                appTheme.orange_600,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 60.h, left: 20.h, right: 20.h, bottom: 20.v),
                            child: Column(
                              children: [
                                _buildDecorativeElementsSection(context),
                                _buildMainContentSection(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.pink),
                    SizedBox(height: 20),
                    Text("Syncing User Data...", style: TextStyle(color: Colors.pink, fontSize: 16)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDecorativeElementsSection(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 16.h, left: 14.h),
          alignment: Alignment.centerLeft,
          child: CustomImageView(
            imagePath: ImageConstant.imgFlash4,
            width: 24.h,
            height: 24.h,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40.h),
          alignment: Alignment.center,
          child: CustomImageView(
            imagePath: ImageConstant.imgSparkles1,
            width: 40.h,
            height: 40.h,
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 28.h),
          alignment: Alignment.centerRight,
          child: CustomImageView(
            imagePath: ImageConstant.imgFlash4,
            width: 24.h,
            height: 24.h,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 70.h, left: 26.h),
          alignment: Alignment.centerLeft,
          child: CustomImageView(
            imagePath: ImageConstant.imgFlash4,
            width: 24.h,
            height: 24.h,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 40.h, left: 28.h, right: 28.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgStar,
                width: 80.h,
                height: 80.h,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16.h, left: 82.h),
                alignment: Alignment.bottomCenter,
                child: CustomImageView(
                  imagePath: ImageConstant.imgFlash4,
                  width: 24.h,
                  height: 24.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainContentSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      child: Column(
        children: [
          Text(
            'Bluestone',
            style: TextStyleHelper.instance.display40BoldPoppins.copyWith(
              height: 1.5,
            ),
          ),
          Text(
            'Group of Institutions',
            style: TextStyleHelper.instance.title22SemiBoldPoppins.copyWith(
              height: 1.5,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 16.h),
            child: Text(
              'Everything you need, all in one place',
              style: TextStyleHelper.instance.title16MediumPoppins.copyWith(
                height: 1.5,
              ),
            ),
          ),
          _buildServicesList(context),
          _buildGetStartedButton(context),
          Container(
            margin: EdgeInsets.only(top: 16.h),
            child: Text(
              'Join thousands of satisfied users',
              style: TextStyleHelper.instance.body13RegularPoppins.copyWith(
                color: appTheme.gray_100,
                height: 1.54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, left: 80.h, right: 80.h),
      child: Column(
        spacing: 10.h,
        children: [
          _buildServiceItem('Education & Career'),
          _buildServiceItem('Sports & Lifestyle'),
          _buildServiceItem('Technology & Innovation'),
        ],
      ),
    );
  }

  Widget _buildServiceItem(String text) {
    return Row(
      spacing: 6.h,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.h,
          height: 6.h,
          decoration: BoxDecoration(
            color: appTheme.yellowA700,
            borderRadius: BorderRadius.circular(3.h),
          ),
        ),
        Text(
          text,
          style: TextStyleHelper.instance.body14MediumPoppins.copyWith(
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return CustomGradientButton(
      text: 'Get Started',
      width: double.infinity,
      rightIcon: ImageConstant.imgSolararrowuplinear,
      onPressed: () {
        context.read<WelcomeProvider>().onGetStartedPressed(context);
      },
    );
  }
}

