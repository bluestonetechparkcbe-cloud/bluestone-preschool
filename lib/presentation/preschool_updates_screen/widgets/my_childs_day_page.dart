import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';
import '../../../../widgets/custom_image_view.dart';

class MyChildsDayPage extends StatelessWidget {
  const MyChildsDayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
           _buildActivityCard(
            title: 'Check Class Activities',
            description: 'MyDay@Bluestone has been updated for today.',
            dateLabel: 'Today',
             dateColor: Color(0xFF1E88E5),
          ),
          SizedBox(height: 16.v),
          _buildActivityCard(
            title: 'Check Class Activities',
            description: 'MyDay@Bluestone has been updated for yesterday.',
            dateLabel: 'Yesterday',
            dateColor: Color(0xFF616161),
          ),
           SizedBox(height: 16.v),
          _buildActivityCard(
            title: 'Check Class Activities',
            description: 'MyDay@Bluestone has been updated for 31 Jan.',
            dateLabel: '31 Jan 2026',
            dateColor: Color(0xFF9E9E9E),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String description,
    required String dateLabel,
    required Color dateColor,
  }) {
    return Container(
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
                  Icon(Icons.open_in_new, color: const Color(0xFF32B6F3), size: 20.adaptSize),
                  SizedBox(width: 16.h),
                  Icon(Icons.share_outlined, color: const Color(0xFF32B6F3), size: 20.adaptSize),
                ],
              ),
           ],
         ),
      ),
        ],
      ),
    );
  }
}
