import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/preschool_menu_provider.dart';

class PreschoolMenuScreen extends StatefulWidget {
  const PreschoolMenuScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolMenuProvider(),
      child: const PreschoolMenuScreen(),
    );
  }

  @override
  State<PreschoolMenuScreen> createState() => _PreschoolMenuScreenState();
}

class _PreschoolMenuScreenState extends State<PreschoolMenuScreen> {
  final List<Map<String, String>> menuItems = [
    {'title': 'Updates', 'icon': ImageConstant.imgIconUpdates},
    {'title': 'Rewards', 'icon': ImageConstant.imgIconRewards},
    {'title': 'My Child’s Day', 'icon': ImageConstant.imgIconChildDay},
    {'title': 'Photo Gallery', 'icon': ImageConstant.imgIconGallery},
    {'title': 'Parent Hub', 'icon': ImageConstant.imgIconParentHub},
    {'title': 'School Connect', 'icon': ImageConstant.imgIconSchoolConnect},
    {'title': 'Teacher Notes', 'icon': ImageConstant.imgIconTeacherNotes},
    {'title': 'Pay Fees', 'icon': ImageConstant.imgIconPayFees},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ================= HEADER =================
            Container(
              height: 260.v,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.h, 60.v, 20.h, 20.v),
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
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32.h),
                  bottomRight: Radius.circular(32.h),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: [
                   // Avatar (Left)
                  Container(
                    padding: EdgeInsets.all(2.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: CustomImageView(
                       imagePath: ImageConstant.imgMenuProfile,
                       height: 64.adaptSize, // Slightly larger per design feel
                       width: 64.adaptSize,
                       radius: BorderRadius.circular(32.h),
                       fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(width: 16.h),

                  // Name + Details + Button (Right)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Left align text block
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lavanya Anbalagan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.fSize,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 4.v),
                        // Number + Email
                        Text(
                          "+91 8489294776 · lavanyanbalagan@gmail.com",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9), 
                            fontSize: 11.fSize, 
                            fontFamily: 'Poppins'
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        SizedBox(height: 8.v),

                        // View Profile Button (Moved inside Column)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: StadiumBorder(),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.h, vertical: 6.v), 
                            minimumSize: Size(0, 0),
                          ),
                          onPressed: () {
                             Navigator.pushNamed(context, AppRoutes.preschoolProfileScreen);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "View Profile",
                                style: TextStyle(
                                  color: Colors.black, 
                                  fontSize: 12.fSize, 
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600 
                                ),
                              ),
                              SizedBox(width: 4.h),
                              Icon(Icons.arrow_forward, size: 14.adaptSize, color: Colors.black)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= OVERLAP SPACE =================
            // Use Transform instead of negative margin or size
            Transform.translate(
              offset: Offset(0, -40.v),
              child: Column(
                children: [
                   // ================= EXPLORE CARD =================
                  Container(
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
                    child: Consumer<PreschoolMenuProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Explore",
                              style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.bold, fontFamily: 'Poppins', color: Colors.black),
                            ),
                            SizedBox(height: 12.v),
                            
                            // Map over menu items defined in state
                            ...menuItems.map((item) => _menuItem(context, item['title']!, item['icon']!, provider)).toList(),
                          ],
                        );
                      }
                    ),
                  ),
                  
                  SizedBox(height: 24.v),

                  // ================= LOGOUT =================
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: GestureDetector(
                       onTap: () {
                           context.read<PreschoolMenuProvider>().onLogoutPressed(context);
                       },
                      child: Row(
                        children: [
                          Icon(Icons.logout, size: 18.adaptSize, color: Colors.black),
                          SizedBox(width: 6.h),
                          Text("Logout", style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Colors.black)),
                          Spacer(),
                          Text(
                            "Version",
                            style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 30.v),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MENU ITEM WIDGET =================
  Widget _menuItem(BuildContext context, String title, String iconPath, PreschoolMenuProvider provider) {
    return GestureDetector(
      onTap: () {
         provider.onMenuItemTap(context, title);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.v),
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 14.v),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.h),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // Using CustomImageView for consistent icon styling from Figma
            // Or use Icons.circle_outlined as placeholder if requested strictly?
            // "Try this code" implies structure. Let's use the image paths for fidelity.
            CustomImageView(
                imagePath: iconPath,
                height: 24.adaptSize,
                width: 24.adaptSize,
            ),
            SizedBox(width: 10.h),
            Expanded(
              child: Text(
                title, 
                style: TextStyle(
                  fontFamily: 'Poppins', 
                  fontWeight: FontWeight.w500, 
                  fontSize: 14.fSize,
                  color: Colors.black,
                )
              )
            ),
            Icon(Icons.arrow_forward_ios, size: 14.adaptSize, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.v, top: 10.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           GestureDetector(
            onTap: () {
               context.read<PreschoolMenuProvider>().onLogoutPressed(context);
            },
             child: Row(
               children: [
                 Icon(Icons.logout, color: Colors.black, size: 20.adaptSize), // Placeholder icon
                 SizedBox(width: 8.h),
                 Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
               ],
             ),
           ),
           Text(
              "Version",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
