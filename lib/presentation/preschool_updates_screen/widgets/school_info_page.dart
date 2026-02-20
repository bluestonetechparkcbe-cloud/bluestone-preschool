import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_export.dart';
import '../provider/preschool_updates_provider.dart';

class SchoolInfoPage extends StatefulWidget {
  const SchoolInfoPage({Key? key}) : super(key: key);

  @override
  State<SchoolInfoPage> createState() => _SchoolInfoPageState();
}

class _SchoolInfoPageState extends State<SchoolInfoPage> {
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreschoolUpdatesProvider>().loadSchoolUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PreschoolUpdatesProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (provider.schoolUpdates.isEmpty) {
             // Show at least one mock item if DB is empty for demo/fallback or just empty state
             // For now return empty state text
             return Center(child: Text("No updates available", style: TextStyle(fontFamily: 'Poppins')));
        }

        return ListView.separated(
          itemCount: provider.schoolUpdates.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.v),
          itemBuilder: (context, index) {
            final update = provider.schoolUpdates[index];
            // Format date label logic (Today, Yesterday, Date)
            // Simplified for now: just use date string or "Today" check
            String dateLabel = _formatDate(update['date']);
            Color dateColor = _getDateColor(dateLabel);

            return _buildInfoCard(
              context,
              title: update['title'] ?? "",
              description: update['description'] ?? "",
              link: update['external_link'],
              dateLabel: dateLabel,
              dateColor: dateColor,
              isNew: update['is_new'] ?? false,
              provider: provider,
            );
          },
        );
      }
    );
  }

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

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String description,
    String? link,
    required String dateLabel,
    required Color dateColor,
    bool isNew = false,
    required PreschoolUpdatesProvider provider,
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
                      GestureDetector(
                        onTap: () => provider.onOpenLink(link),
                        child: Text(
                          link,
                          style: TextStyle(
                            color: const Color(0xFF32B6F3),
                            fontSize: 13.fSize,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
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
                 IconButton(
                    onPressed: () {
                         String shareText = "*$title*\n\n$description";
                         if (link != null && link.isNotEmpty) {
                           shareText += "\n\nRead more: $link";
                         }
                         provider.onShare(shareText, subject: title);
                    },
                   icon: Icon(
                     Icons.share_outlined,
                     color: const Color(0xFF32B6F3),
                     size: 20.adaptSize,
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
