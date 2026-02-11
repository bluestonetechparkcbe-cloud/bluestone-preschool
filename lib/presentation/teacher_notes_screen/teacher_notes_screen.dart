import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';

class TeacherNotesScreen extends StatelessWidget {
  const TeacherNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgUpdatesBg), // Consistent background with Updates Sceen
            fit: BoxFit.cover,
          ),
        ),
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
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          "Teacher notes",
                          style: TextStyle(
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

              SizedBox(height: 8.v),

              /// SUBTITLE
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.h),
                child: Text(
                  "Specific feedback and developmental milestones observed by the teacher",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.fSize, fontFamily: 'Poppins'),
                ),
              ),

              SizedBox(height: 24.v),

              /// TODAY LINE
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Row(
                  children: [
                    Text(
                      "TODAY",
                      style:
                          TextStyle(fontSize: 16.fSize, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      child: Divider(thickness: 1),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.v),

              /// NOTES LIST
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  children: [
                    TeacherNoteCard(
                      title: "Showing Kindness",
                      description:
                          "Today your child shared toys with classmates willingly and displayed kindness by offering help to a friend who needed assistance.",
                      imageUrl: ImageConstant.imgShowingKindness,
                      isNetworkImage: false,
                    ),
                    SizedBox(height: 16.v),
                    TeacherNoteCard(
                      title: "Growing independence",
                      description:
                          "Your child independently put on their shoes today. They are showing great progress in self care and following routines on their own.",
                      imageUrl: ImageConstant.imgGrowingIndependence,
                      isNetworkImage: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherNoteCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final bool isNetworkImage;

  const TeacherNoteCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isNetworkImage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                       TextStyle(fontSize: 14.fSize, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                ),
                SizedBox(height: 6.v),
                Text(
                  description,
                  style: TextStyle(fontSize: 13.fSize, fontFamily: 'Poppins', height: 1.4),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.h),

          /// IMAGE
          CustomImageView(
            imagePath: imageUrl,
            height: 100.adaptSize,
            width: 100.adaptSize,
            radius: BorderRadius.circular(10.h),
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
