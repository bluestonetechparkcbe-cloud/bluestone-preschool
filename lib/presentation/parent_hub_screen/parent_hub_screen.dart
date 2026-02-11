import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class ParentHubScreen extends StatelessWidget {
  const ParentHubScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ParentHubScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgUpdatesBg), // Consistent background
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.v),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              SizedBox(height: 10.v),
              _buildWeekSelector(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Smart Parenting - Week 31',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 16.v),
                        _buildParentingCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20.adaptSize, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            'Parent Hub',
            style: TextStyle(
              fontSize: 22.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 40.h), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildWeekSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.all(4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          _weekTab('Week 29', false),
          _weekTab('Week 30', false),
          _weekTab('Week 31', true),
          _weekTab('Week 32', false),
        ],
      ),
    );
  }

  Widget _weekTab(String label, bool isSelected) {
    return Expanded(
      child: Container(
        height: 36.v,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF32B6F3) : Colors.transparent,
          borderRadius: BorderRadius.circular(10.h),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13.fSize,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildParentingCard() {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.h),
                child: CustomImageView(
                  imagePath: ImageConstant.imgParentingTips, 
                  height: 200.v,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 6.v),
                  decoration: BoxDecoration(
                    color: const Color(0xFF32B6F3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.h),
                      bottomRight: Radius.circular(15.h),
                    ),
                  ),
                  child: Text(
                    'Week 31',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.fSize, fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.v),
          Text(
            'Parenting Tips',
            style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.bold, fontFamily: 'Poppins'),
          ),
          SizedBox(height: 6.v),
          Text(
            'Read helpful tips and advice tailored for week 31 of your parenting journey.',
            style: TextStyle(color: Colors.grey, fontSize: 14.fSize, fontFamily: 'Poppins', height: 1.5),
          ),
          SizedBox(height: 16.v),
          
          SizedBox(
            height: 32.v,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF32B6F3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.h)), // Fully rounded for button
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 16.h), // Hug content horizontally
              ),
               child: Row(
                mainAxisSize: MainAxisSize.min, // Hug content
                children: [
                  Text('View Tips', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 12.fSize)), // Adjusted font size for smaller button
                  SizedBox(width: 8.h),
                  Icon(Icons.arrow_forward, size: 14.adaptSize),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
