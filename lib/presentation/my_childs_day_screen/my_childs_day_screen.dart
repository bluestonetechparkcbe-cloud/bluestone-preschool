import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/my_childs_day_provider.dart';

class MyChildsDayScreen extends StatefulWidget {
  const MyChildsDayScreen({Key? key}) : super(key: key);

  @override
  State<MyChildsDayScreen> createState() => _MyChildsDayScreenState();
}

class _MyChildsDayScreenState extends State<MyChildsDayScreen> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (args is DateTime) {
          // If date passed, load specific date
          context.read<MyChildsDayProvider>().loadActivities(date: args);
        } else {
          // Default to today
          context.read<MyChildsDayProvider>().loadActivities(date: DateTime.now());
        }
      });
      _isInit = false;
    }
  }

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
                _buildHeader(context),
                SizedBox(height: 12.v),
                _buildDropdowns(context),
                SizedBox(height: 20.v),
                _buildSwitchTodayButton(context),
                SizedBox(height: 20.v),
                _buildContentCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
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
    );
  }

  Widget _buildDropdowns(BuildContext context) {
    return Consumer<MyChildsDayProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            // Terrain Tales - Clickable Theme Selector
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
                  ),
                  builder: (context) {
                    return Container(
                      padding: EdgeInsets.all(20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Select Curriculum Theme", style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
                          SizedBox(height: 10.v),
                          Divider(),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: provider.themes.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(provider.themes[index], style: TextStyle(fontFamily: 'Poppins')),
                                  onTap: () {
                                    provider.updateTheme(provider.themes[index]);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
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
                    Expanded(
                      child: Text(
                        provider.currentTheme,
                        style: TextStyle(
                          fontSize: 16.fSize,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),
            SizedBox(height: 14.v),
            // Week & Day Dropdowns
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: provider.selectedWeek,
                          hint: Text("Week", style: TextStyle(fontFamily: 'Poppins', color: Colors.black54)),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
                          isExpanded: true,
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: Colors.black),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                               // If day is not selected, default to 1
                              provider.loadActivitiesByWeekDay(newValue, provider.selectedDay ?? 1);
                            }
                          },
                          items: List.generate(40, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text("Week $value"),
                            );
                          }).toList(),
                        ),
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
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: provider.selectedDay,
                          hint: Text("Day", style: TextStyle(fontFamily: 'Poppins', color: Colors.black54)),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black54),
                          isExpanded: true,
                          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: Colors.black),
                          onChanged: (int? newValue) {
                            if (newValue != null) {
                               // If week is not selected, default to 31 (as per user data) or alert user? 
                               // For now default to 31 if null to avoid crash, or match requirement.
                              provider.loadActivitiesByWeekDay(provider.selectedWeek ?? 31, newValue);
                            }
                          },
                          items: List.generate(5, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text("Day $value"),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSwitchTodayButton(BuildContext context) {
    return Consumer<MyChildsDayProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Row(
            children: [
              Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1.5, endIndent: 10)),
              GestureDetector(
                onTap: provider.switchToToday,
                child: Container(
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
                    border: Border.all(color: Colors.yellow, width: 1.5),
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
              ),
              Expanded(child: Divider(color: Colors.white.withOpacity(0.5), thickness: 1.5, indent: 10)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContentCard(BuildContext context) {
    return Consumer<MyChildsDayProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Container(
            padding: EdgeInsets.all(16.h),
            width: double.infinity,
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                          provider.studentName ?? "Student Name",
                          style: TextStyle(
                            fontSize: 16.fSize,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          provider.isDateMode 
                              ? _formatDate(provider.selectedDate)
                              : "Week ${provider.selectedWeek} / Day ${provider.selectedDay} Activities",
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
                
                if (provider.activities.isEmpty)
                   Center(child: Padding(
                     padding: EdgeInsets.all(20.0),
                     child: Text("No activities recorded for this selection.", textAlign: TextAlign.center),
                   ))
                else
                  ...provider.activities.map((activity) => _activityTile(
                    text: activity['activity_text'] ?? "",
                    bgColor: _getBgColorForType(activity['activity_type']),
                    iconWidget: _getIconForType(activity['activity_type']),
                  )).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Today’s Learning Activities";
    }
    return "${date.day}/${date.month}/${date.year} Learning Activities";
  }
  
  Color _getBgColorForType(String? type) {
    switch(type) {
      case 'world': return Color(0xFFFCF3EE);
      case 'puzzle': return Color(0xFFEFF2FD);
      case 'alphabet': return Color(0xFFEBF4FB);
      case 'physical': return Color(0xFFFEF5E7);
      case 'number': 
      case 'numbers': return Color(0xFFF0EEFD);
      default: return Color(0xFFF5F5F5);
    }
  }

  Widget _getIconForType(String? type) {
    IconData icon;
    Color color = Colors.black54; 
    
    switch(type) {
      case 'world': icon = Icons.public; color = Colors.brown; break;
      case 'puzzle': icon = Icons.extension; color = Colors.blue; break;
      case 'alphabet': icon = Icons.font_download; color = Colors.indigo; break;
      case 'physical': icon = Icons.directions_run; color = Colors.orange; break;
      case 'number': 
      case 'numbers': icon = Icons.format_list_numbered; color = Colors.purple; break;
      default: icon = Icons.star;
    }
    
    return Icon(icon, color: color, size: 24.adaptSize);
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
            width: 32.adaptSize,
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
