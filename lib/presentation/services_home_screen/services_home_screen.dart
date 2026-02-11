import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_image_view.dart';
import './provider/services_home_provider.dart';

class ServicesHomeScreen extends StatefulWidget {
  ServicesHomeScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider<ServicesHomeProvider>(
      create: (context) => ServicesHomeProvider()..initialize(),
      child: ServicesHomeScreen(),
    );
  }

  @override
  State<ServicesHomeScreen> createState() => _ServicesHomeScreenState();
}

class _ServicesHomeScreenState extends State<ServicesHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteCustom,
      body: Consumer<ServicesHomeProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context, provider),
                _buildExploreServicesSection(context, provider),
                _buildServicesGrid(context, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    ServicesHomeProvider provider,
  ) {
    return SizedBox(
      height: 290.h, // Increased to restore visual balance
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Gradient Background
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: 250.h, // Increased to match proportion
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF2D7A), appTheme.pink_500, appTheme.orange_600],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.h),
                  bottomRight: Radius.circular(32.h),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Container(
                margin: EdgeInsets.only(top: 80.h),
                child: Row(
                  spacing: 10.h,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Hey there!",
                                style:
                                    TextStyleHelper.instance.headline24BoldPoppins,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 6.h),
                                child: CustomImageView(
                                  imagePath: ImageConstant.imgWave1,
                                  height: 24.h,
                                  width: 24.h,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "What are you looking for today?",
                            style: TextStyleHelper.instance.body13MediumPoppins,
                          ),
                        ],
                      ),
                    ),
                    CustomIconButton(
                      onPressed: () => provider.onProfileTap(),
                      iconPath: ImageConstant.imgIconamoonProfile,
                      backgroundColor: appTheme.color33FFFF,
                      borderRadius: 20.h,
                      width: 40.h,
                      height: 40.h,
                    ),
                    CustomIconButton(
                      onPressed: () => provider.onNotificationTap(),
                      iconPath: ImageConstant.imgMdiBellOutline,
                      backgroundColor: appTheme.color33FFFF,
                      borderRadius: 20.h,
                      width: 40.h,
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Active Services Card
          Positioned(
            bottom: 0,
            left: 20.h,
            right: 20.h,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: appTheme.whiteCustom,
                borderRadius: BorderRadius.circular(12.h),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.color260000,
                    offset: Offset(0, 8.h),
                    blurRadius: 24.h,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.h),
              child: Row(
                spacing: 10.h,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    iconPath: ImageConstant.imgMingcuteLightningFill,
                    backgroundColor: appTheme.yellowA700,
                    borderRadius: 10.h,
                    width: 32.h,
                    height: 32.h,
                    padding: EdgeInsets.all(6.h),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Active Services",
                          style: TextStyleHelper.instance.body13RegularPoppins,
                        ),
                        Text(
                          "9 Available",
                          style: TextStyleHelper.instance.title18BoldPoppins,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Members",
                        style: TextStyleHelper.instance.body13RegularPoppins,
                      ),
                      Text(
                        "15000+",
                        style: TextStyleHelper.instance.title18BoldPoppins,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreServicesSection(
    BuildContext context,
    ServicesHomeProvider provider,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 84.h, left: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore Services",
            style: TextStyleHelper.instance.title20BoldPoppins,
          ),
          Container(
            margin: EdgeInsets.only(top: 0.h),
            child: Text(
              "Tap to discover more",
              style: TextStyleHelper.instance.body13RegularPoppins,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesGrid(
    BuildContext context,
    ServicesHomeProvider provider,
  ) {
    return Container(
      width: double.infinity,
      height: 428.h,
      margin: EdgeInsets.only(top: 16.h),
      child: Stack(
        children: [
          // Row 1
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onServiceTap('overseas'),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgChatgptImageJan,
                      height: 168.h,
                      width: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onServiceTap('ias_academy'),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgChatgptImageJan168x168,
                      height: 168.h,
                      width: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onServiceTap('placements'),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgChatgptImageJan168x158,
                      height: 168.h,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Row 2
          Positioned(
            top: 130.h,
            child: SizedBox(
              width: 390.h,
              height: 168.h,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => provider.onServiceTap('elite_sports'),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgChatgptImageJan168x160,
                        height: 168.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => provider.onServiceTap('tech_park'),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgChatgptImageJan1,
                        height: 168.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => provider.onServiceTap('language_hub'),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgChatgptImageJan2,
                        height: 168.h,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Row 3
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onServiceTap('preschool'),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgChatgptImageJan3,
                      height: 168.h,
                      width: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onServiceTap('startup'),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgChatgptImageJan4,
                      height: 168.h,
                      width: double.infinity,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => provider.onServiceTap('fun_zone'),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgChatgptImageJan5,
                      height: 168.h,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
