import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/preschool_home_provider.dart';

class PreschoolHomeScreen extends StatefulWidget {
  const PreschoolHomeScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolHomeProvider(),
      child: const PreschoolHomeScreen(),
    );
  }

  @override
  State<PreschoolHomeScreen> createState() => _PreschoolHomeScreenState();
}

class _PreschoolHomeScreenState extends State<PreschoolHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgHomeBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Transparent Clickable Area for "Parent Corner" (Top Right based on HomePs)
             GestureDetector(
                onTap: () {
                  context.read<PreschoolHomeProvider>().onParentCornerPressed(context);
                },
                child: Container(
                  width: 120.h,
                  height: 60.v,
                  color: Colors.transparent, // Invisible touch target
                  alignment: Alignment.center,
                  // Debug color (remove later): color: Colors.red.withOpacity(0.3), 
                ),
              ),
              Spacer(),
              // Additional UI elements from design can be added here as positioned widgets if needed
            ],
          ),
        ),
      ),
    );
  }
}
