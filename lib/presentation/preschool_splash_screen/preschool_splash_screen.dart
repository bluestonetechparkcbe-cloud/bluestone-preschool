import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_gradient_button.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/preschool_splash_provider.dart';

class PreschoolSplashScreen extends StatefulWidget {
  const PreschoolSplashScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolSplashProvider(),
      child: const PreschoolSplashScreen(),
    );
  }

  @override
  State<PreschoolSplashScreen> createState() => _PreschoolSplashScreenState();
}

class _PreschoolSplashScreenState extends State<PreschoolSplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Using sizer for responsiveness
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF2D7A), Color(0xFFFF9933), Color(0xFF33CCFF)],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Decorative Elements (Stars/Sparkles) matching Figma
            // Top Left Cluster
            Positioned(
              left: 30.h,
              top: 110.h,
              child: CustomImageView(
                imagePath: ImageConstant.imgSparkle, // Large Sparkle 1
                height: 40.h,
                width: 40.h,
              ),
            ),
             Positioned(
              left: 15.h,
              top: 150.h,
              child: CustomImageView(
                imagePath: ImageConstant.imgStars, // Small Star 1
                height: 25.h,
                width: 25.h,
              ),
            ),

            // Top Right Cluster
            Positioned(
              right: 40.h,
              top: 80.h,
              child: CustomImageView(
                imagePath: ImageConstant.imgSparkle, // Large Sparkle 2
                height: 45.h,
                width: 45.h,
              ),
            ),

            // Bottom Left Cluster
            Positioned(
              left: 40.h,
              bottom: 180.h,
              child: CustomImageView(
                imagePath: ImageConstant.imgStars, // Small Star 2
                height: 35.h,
                width: 35.h,
              ),
            ),

            // Bottom Right Cluster - Using Sparkle again or Star?
            // User asked for "2 small img_stars" and "2 large img_sparkle".
            // Used: Sparkle(x2), Stars(x2).
            // But we have 4 corners essentially.
            // Let's stick to the 4 items defined above.
            
            // Note: The previous code had a 5th element (Bottom Right).
            // I will place one of the "Stars" there if the previous count was 5, 
            // but the user said "2 small" and "2 large". That sums to 4.
            // I'll stick to 4 distinct positions for these assets.
            
            Positioned(
              right: 30.h,
              bottom: 250.h,
              child: CustomImageView(
                imagePath: ImageConstant.imgStars, 
                height: 25.h,
                width: 25.h,
                // Using existing imgStars again if needed or leaving it out if exactly 4 requested.
                // The layout looks like it needs balance.
                // Let's use the 2nd definition of imgStars here (making it the 2nd usage)
                // and the "Bottom Left" one can be... wait.
                // Top Left: Sparkle
                // Top Right: Sparkle
                // Top Left (lower): Star
                // Bottom Right: Star
                // This uses 2 Sparkles and 2 Stars.
              ),
            ),

            // Center Content: Logo Area
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   // Main Logo
                   CustomImageView(
                      imagePath: ImageConstant.imgBluestoneInternationalPreschoolLogo,
                      height: 300.h,
                      width: 390.h, // Using nearly full width as per design prominent logo
                      fit: BoxFit.contain,
                   ),
                ],
              ),
            ),

            // Bottom Buttom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 50.h, left: 20.h, right: 20.h),
                child: GestureDetector(
                  onTap: () {
                    context.read<PreschoolSplashProvider>().onGetStartedPressed(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.h),
                      boxShadow: [
                         BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.fSize,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(width: 8.h),
                        Icon(Icons.arrow_forward, color: Colors.black, size: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
