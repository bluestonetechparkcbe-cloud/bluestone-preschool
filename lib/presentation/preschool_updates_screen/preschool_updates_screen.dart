import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import 'provider/preschool_updates_provider.dart';
import 'widgets/school_info_page.dart';
import 'widgets/my_childs_day_page.dart';

class PreschoolUpdatesScreen extends StatefulWidget {
  const PreschoolUpdatesScreen({Key? key}) : super(key: key);

  @override
  PreschoolUpdatesScreenState createState() => PreschoolUpdatesScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolUpdatesProvider(),
      child: PreschoolUpdatesScreen(),
    );
  }
}

class PreschoolUpdatesScreenState extends State<PreschoolUpdatesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreschoolUpdatesProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Header with Background Image
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 20.h, right: 20.h, top: 48.v, bottom: 20.v),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageConstant.imgUpdatesBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                         SizedBox(width: double.infinity),
                        Text(
                          'Updates',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black, // Changed to black
                            fontSize: 20.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                         Positioned(
                          left: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black, // Changed to black
                              size: 24.adaptSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent, // Background handled by main scaffold or image if needed, but here likely white/transparent
                  ),
                  child: Column(
                    children: [
                      // Custom Tab Bar
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        height: 48.v, // Slightly taller for the pill shape
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.h), // Fully rounded
                          boxShadow: [
                             BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            _buildTabItem(
                              context,
                              title: 'School Info',
                              index: 0,
                              isSelected: provider.selectedTabIndex == 0,
                            ),
                            _buildTabItem(
                              context,
                              title: 'My Child’s Day',
                              index: 1,
                              isSelected: provider.selectedTabIndex == 1,
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: 20.v),
                      
                      // Body Content
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          child: provider.selectedTabIndex == 0
                              ? SchoolInfoPage()
                              : MyChildsDayPage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required String title,
    required int index,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<PreschoolUpdatesProvider>().onTabChanged(index);
        },
        child: Container(
          margin: EdgeInsets.all(4.h), // Margin for the pill effect
          height: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF32B6F3) : Colors.transparent,
            borderRadius: BorderRadius.circular(20.h),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
