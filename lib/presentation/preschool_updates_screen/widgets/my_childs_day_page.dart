import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../widgets/custom_image_view.dart';
import 'package:provider/provider.dart';
import '../provider/preschool_updates_provider.dart';
import '../../../../routes/app_routes.dart';

class MyChildsDayPage extends StatefulWidget {
  const MyChildsDayPage({Key? key}) : super(key: key);

  @override
  State<MyChildsDayPage> createState() => _MyChildsDayPageState();
}

class _MyChildsDayPageState extends State<MyChildsDayPage> {
  @override
   void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreschoolUpdatesProvider>().loadStudentLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreschoolUpdatesProvider>(
      builder: (context, provider, child) {
         if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.studentLogs.isEmpty) {
             return Center(child: Text("No logs available for your child", style: TextStyle(fontFamily: 'Poppins')));
        }
        
         return ListView.separated(
          itemCount: provider.studentLogs.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.v),
          itemBuilder: (context, index) {
            final log = provider.studentLogs[index];
             // Format date label logic
            String dateLabel = _formatDate(log['date']);
            Color dateColor = _getDateColor(dateLabel);

            return _buildActivityCard(
              context,
              title: log['title'] ?? "",
              description: log['description'] ?? "",
              dateLabel: dateLabel,
              dateColor: dateColor,
              onShare: () => provider.shareStudentLog(log),
              logDate: log['date'],
            );
          },
        );
      }
    );
  }
  
  // Reusing helper methods or move to utils
  String _formatDate(DateTime? date) {
    if (date == null) return "N/A";
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(date.year, date.month, date.day);
    
    if (inputDate == today) return "Today";
    if (inputDate == today.subtract(Duration(days: 1))) return "Yesterday";
    return "${date.day} ${_getMonth(date.month)} ${date.year}";
  }
  
  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Color _getDateColor(String label) {
    if (label == "Today") return Color(0xFF1E88E5);
    if (label == "Yesterday") return Color(0xFF616161);
    return Color(0xFF9E9E9E);
  }

  Widget _buildActivityCard(
    BuildContext context, {
    required String title,
    required String description,
    required String dateLabel,
    required Color dateColor,
    required VoidCallback onShare,
    DateTime? logDate,
  }) {
    return GestureDetector(
      onTap: () {
         Navigator.pushNamed(context, AppRoutes.myChildsDayScreen, arguments: logDate);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20.v, left: 16.h, right: 16.h, bottom: 12.v),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 // Activity Image / Icon
                 Container(
                   margin: EdgeInsets.only(right: 12.h),
                   height: 48.adaptSize,
                   width: 48.adaptSize,
                   decoration: BoxDecoration(
                     color: Colors.orange.shade50,
                     borderRadius: BorderRadius.circular(12.h),
                   ),
                   child: Padding(
                     padding: EdgeInsets.all(8.h),
                     child: CustomImageView(
                       imagePath: ImageConstant.imgTeddy, // Use teddy as placeholder for activity
                       height: 32.adaptSize,
                       width: 32.adaptSize,
                       fit: BoxFit.contain,
                     ),
                   ),
                 ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                       SizedBox(height: 4.v),
                      Text(
                        description,
                         style: TextStyle(
                          color: const Color(0xFF555555),
                          fontSize: 13.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
             SizedBox(height: 16.v),
            Container(
               padding: EdgeInsets.only(top: 12.v),
               decoration: BoxDecoration(
                 border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
               // Date Label with filled background
               Container(
                 padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 6.v),
                 decoration: BoxDecoration(
                   color: dateColor, // Filled background
                   borderRadius: BorderRadius.circular(16.h),
                 ),
                 child: Text(
                   dateLabel,
                   style: TextStyle(
                   color: Colors.white, // White text
                     fontSize: 12.fSize,
                     fontFamily: 'Poppins',
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ),
               // Icons: Share + Open
                Row(
                  children: [
                     IconButton(
                      icon: Icon(Icons.open_in_new, color: const Color(0xFF32B6F3), size: 20.adaptSize),
                      onPressed: () {
                         Navigator.pushNamed(context, AppRoutes.myChildsDayScreen, arguments: logDate);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: const Color(0xFF32B6F3), size: 20.adaptSize),
                      onPressed: onShare,
                    ),
                  ],
                ),
             ],
           ),
        ),
          ],
        ),
      ),
    );
  }
}
