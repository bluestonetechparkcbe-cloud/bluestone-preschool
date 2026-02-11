import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class MyChildsDayScreen extends StatelessWidget {
  const MyChildsDayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgUpdatesBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 48.v, bottom: 20.v),
            child: Column(
              children: [
                /// APP BAR
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.adaptSize),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "My Child’s Day",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.fSize,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.h),
                    ],
                  ),
                ),

                SizedBox(height: 12.v),

                /// TERRAIN TALES DROPDOWN
                Container(
                  height: 52.v,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  padding: EdgeInsets.symmetric(horizontal: 14.h),
                  decoration: _cardDecoration(),
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgTerrainTales, 
                        height: 40.adaptSize,
                        width: 40.adaptSize,
                        radius: BorderRadius.circular(20.h),
                      ),
                      SizedBox(width: 10.h),
                      Text(
                        "Terrain Tales",
                        style: TextStyle(
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_drop_down, color: Colors.black54),
                    ],
                  ),
                ),

                SizedBox(height: 14.v),

                /// WEEK & DAY
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 36.v,
                          decoration: _cardDecoration(),
                          padding: EdgeInsets.symmetric(horizontal: 12.h),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min, // Center content
                            children: [
                              Text("Week 31", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                               SizedBox(width: 4.h),
                              Icon(Icons.arrow_drop_down, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      Expanded(
                        child: Container(
                           height: 36.v,
                           decoration: _cardDecoration(),
                           padding: EdgeInsets.symmetric(horizontal: 12.h),
                           alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                             mainAxisSize: MainAxisSize.min, // Center content
                            children: [
                               Text("Day 1", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
                                SizedBox(width: 4.h),
                               Icon(Icons.arrow_drop_down, color: Colors.black54),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.v),

                /// SWITCH TODAY BUTTON WITH LINES
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1.5, endIndent: 10)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.v),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.h),
                           boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                          border: Border.all(color: Colors.yellow, width: 1.5), // Yellow border for pill
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgCalendar,
                            height: 18.adaptSize,
                            width: 18.adaptSize,
                          ),
                          SizedBox(width: 8.h),
                          Text(
                            "Switch to today",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14.fSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1.5, indent: 10)),
                    ],
                  ),
                ),

                SizedBox(height: 20.v),

                /// CONTENT CARD
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Container(
                    padding: EdgeInsets.all(16.h),
                    width: double.infinity,
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Fit content height
                      children: [
                        /// STUDENT HEADER
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgMenuProfile,
                              height: 48.adaptSize,
                              width: 48.adaptSize,
                              radius: BorderRadius.circular(24.h),
                            ),
                            SizedBox(width: 12.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lavanya A",
                                  style: TextStyle(
                                    fontSize: 16.fSize,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Today’s Learning Activities",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                    fontSize: 12.fSize,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 20.v),

                         _activityTile(
                            text: "Learned different Landforms on the Earth",
                            bgColor: const Color(0xFFFCF3EE),
                            iconWidget: CustomImageView(imagePath: ImageConstant.imgGlobe, height: 24.adaptSize, width: 24.adaptSize),
                        ),
                        _activityTile(
                            text: "Practiced self-control through ‘Stop, Think, Act’ activity",
                            bgColor: const Color(0xFFEFF2FD),
                            iconWidget: CustomImageView(imagePath: ImageConstant.imgPuzzle, height: 24.adaptSize, width: 24.adaptSize),
                        ),
                        _activityTile(
                            text: "Understood long vowel ‘ie’ family words",
                            bgColor: const Color(0xFFEBF4FB),
                            iconWidget: CustomImageView(imagePath: ImageConstant.imgAbcBlocks, height: 24.adaptSize, width: 24.adaptSize),
                        ),
                        _activityTile(
                            text: "Participated in physical activities",
                            bgColor: const Color(0xFFFEF5E7),
                             iconWidget: CustomImageView(imagePath: ImageConstant.imgPhysicalActivities, height: 24.adaptSize, width: 24.adaptSize),
                        ),
                        _activityTile(
                            text: "Learned numbers from 161 to 170 through number cards",
                            bgColor: const Color(0xFFF0EEFD),
                             iconWidget: CustomImageView(imagePath: ImageConstant.imgNumberBlocks, height: 24.adaptSize, width: 24.adaptSize),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _whiteCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.v),
      decoration: _cardDecoration(),
      child: child,
    );
  }

  Widget _centerText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
      ),
    );
  }

  Widget _activityTile({required String text, required Color bgColor, required Widget iconWidget}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.v),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.h),
      ),
      child: Row(
        children: [
          Container(
            width: 32.adaptSize, // Fixed width for alignment
            alignment: Alignment.center,
            child: iconWidget,
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.fSize,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.h),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}
