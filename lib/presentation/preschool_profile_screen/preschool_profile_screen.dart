import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../widgets/custom_image_view.dart';
import 'provider/preschool_profile_provider.dart';

class PreschoolProfileScreen extends StatefulWidget {
  const PreschoolProfileScreen({Key? key}) : super(key: key);

  @override
  PreschoolProfileScreenState createState() => PreschoolProfileScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolProfileProvider(),
      child: PreschoolProfileScreen(),
    );
  }
}

class PreschoolProfileScreenState extends State<PreschoolProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreschoolProfileProvider>().loadProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
              height: 220.v,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16.h, 60.v, 16.h, 20.v),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF3366),
                    Color(0xFFFF9933),
                    Color(0xFF33CCFF),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                   IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20.adaptSize),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.fSize,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40.h), // To balance the back button
                ],
              ),
            ),

            // ================= PROFILE CARD =================
            Transform.translate(
              offset: Offset(0, -40.v),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.h),
                padding: EdgeInsets.all(16.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.h),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: Column(
                  children: [

                    // Avatar
                    Container(
                        height: 100.adaptSize,
                        width: 100.adaptSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgMenuProfile,
                          height: 100.adaptSize,
                          width: 100.adaptSize,
                          radius: BorderRadius.circular(50.h),
                          fit: BoxFit.cover,
                        ),
                    ),

                    SizedBox(height: 12.v),

                    Consumer<PreschoolProfileProvider>(
                      builder: (context, provider, child) {
                        final model = provider.preschoolProfileModelObj;
                        return Column(
                          children: [
                            Text(
                              model.studentName.isNotEmpty ? model.studentName : "Loading...",
                              style: TextStyle(fontSize: 22.fSize, fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 4.v),
                            Text(
                              "Nestler", // Keeping static as requested logic didn't specify dynamic school name
                              style: TextStyle(color: Colors.grey, fontSize: 14.fSize, fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 24.v),

                            _infoTile("UIN", model.uin, Icons.credit_card),
                            _infoTile("Grade", model.grade, Icons.grade), // Added Grade
                            _infoTile("Gender", model.gender, Icons.female), // Icon might need logic based on gender but sticking to female for now or generic person
                            _infoTile(
                                "Father",
                                "${model.fatherName}\n${model.fatherEmail}\n${model.fatherPhone}", Icons.family_restroom),
                            _infoTile(
                                "Mother",
                                "${model.motherName}\n${model.motherEmail}\n${model.motherPhone}", Icons.family_restroom),
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INFO TILE =================
  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.v),
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12.h),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to top for multiline
        children: [
          Container(
            height: 36.adaptSize,
            width: 36.adaptSize,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD600),
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Icon(icon, color: Colors.white, size: 20.adaptSize), // White icon as per user code implies? User code had info_outline default. 
            // Wait, previous code had Icon(Icons.info_outline). The yellow box usually implies white or black icon. 
            // User code: child: const Icon(Icons.info_outline), inside yellow box. 
            // Default icon color is black. Let's stick to black or white? 
            // Previous implementations used white on yellow. User code didn't specify color, so it would be black.
            // Let's use Colors.black for high contrast on Yellow, or White if that was the "Yellow Icon" style.
            // Actually, `infoTile` in user code has: `child: const Icon(Icons.info_outline)`.
            // Let's use `Icons.person` etc based on content.
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.fSize,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4.v),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    height: 1.3,
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
