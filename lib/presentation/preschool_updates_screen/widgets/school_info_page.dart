import 'package:flutter/material.dart';
import '../../../../core/app_export.dart';

class SchoolInfoPage extends StatelessWidget {
  const SchoolInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInfoCard(
            title: 'Give Your The Confidence To Speak and shine',
            description: 'Know a parent searching for a preschool? Share this message with them.\nEurokids, powred by Heureka, builds fluent speakers and confidentncommunicators from the yearly years.',
            link: 'https://eurokidsgroup.co.in/pn1',
            dateLabel: 'Today',
            dateColor: Color(0xFF1E88E5), // Blue
            isNew: true,
          ),
          SizedBox(height: 16.v),
          _buildInfoCard(
            title: 'We’d love your feedback!',
            description: 'Dear Parent,\nPlease check your Whatsapp for a short 3-min survey link from EuroKids. Your inputs will help us understand how we can better support your child’s transition to the 1st Grade.',
            link: null,
            dateLabel: 'Yesterday',
            dateColor: Color(0xFF616161), // Grey
          ),
          SizedBox(height: 16.v),
          // Additional item to fill space if needed
           _buildInfoCard(
            title: 'We’d love your feedback!',
            description: 'Dear Parent,\nPlease check your Whatsapp for a short 3-min survey link from EuroKids. Your inputs will help us understand how we can better support your child’s transition to the 1st Grade.',
            link: null,
            dateLabel: '31 Jan 2026',
            dateColor: Color(0xFF9E9E9E), // Light Grey
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String description,
    String? link,
    required String dateLabel,
    required Color dateColor,
    bool isNew = false,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(isNew)
                      Container(
                        margin: EdgeInsets.only(bottom: 8.v),
                        padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                        child: Text(
                          "NEW",
                          style: TextStyle(color: Colors.white, fontSize: 10.fSize, fontWeight: FontWeight.bold),
                        ),
                      ),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.fSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 6.v),
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
                    if (link != null) ...[
                      SizedBox(height: 6.v),
                      Text(
                        link,
                        style: TextStyle(
                          color: const Color(0xFF32B6F3),
                          fontSize: 13.fSize,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
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
                  Icon(
                    Icons.share_outlined,
                    color: const Color(0xFF32B6F3),
                    size: 20.adaptSize,
                  ),
               ],
             ),
          ),
        ],
      ),
    );
  }
}
