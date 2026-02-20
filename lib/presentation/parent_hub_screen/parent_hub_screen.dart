import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import '../../db_helper.dart';
import '../teacher_notes_screen/teacher_note_detail_screen.dart'; 
import 'pdf_viewer_screen.dart';

class ParentHubScreen extends StatefulWidget {
  const ParentHubScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ParentHubScreen();
  }

  @override
  State<ParentHubScreen> createState() => _ParentHubScreenState();
}

class _ParentHubScreenState extends State<ParentHubScreen> {
  int? _selectedWeek;
  late Future<List<int>> _weeksFuture;
  Future<List<Map<String, dynamic>>>? _contentFuture;

  @override
  void initState() {
    super.initState();
    _weeksFuture = DBHelper.initParentHub().then((_) {
      return DBHelper.getAvailableWeeks().then((weeks) {
        if (weeks.isNotEmpty) {
          // Default to latest week; ensure we schedule a rebuild to fetch content
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedWeek = weeks.first;
                _loadContent();
              });
            }
          });
        }
        return weeks;
      });
    });
  }

  void _loadContent() {
    if (_selectedWeek != null) {
      _contentFuture = DBHelper.getParentHubContent(_selectedWeek!);
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.v),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context),
              SizedBox(height: 10.v),
              
              // Weeks Future Builder
              FutureBuilder<List<int>>(
                future: _weeksFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox(); 
                  return _buildWeekDropdown(snapshot.data!);
                },
              ),

              Expanded(
                child: _contentFuture == null
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<List<Map<String, dynamic>>>(
                      future: _contentFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        
                        final allItems = snapshot.data ?? [];
                        
                        // Group Items
                        final smartParenting = allItems.where((i) => i['type'] == 'Smart Parenting').toList();
                        final weekEndLetters = allItems.where((i) => i['type'] == 'Week End Letter').toList();

                        if (allItems.isEmpty) {
                           return Center(
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Container(
                                   padding: EdgeInsets.all(20.h),
                                   decoration: BoxDecoration(
                                     color: Colors.white.withOpacity(0.5),
                                     shape: BoxShape.circle,
                                   ),
                                   child: Icon(Icons.rocket_launch, size: 50.adaptSize, color: Colors.blueAccent),
                                 ),
                                 SizedBox(height: 16.v),
                                 Text(
                                   "Resources for this week are coming soon!",
                                   style: TextStyle(
                                     color: Colors.black87, 
                                     fontSize: 16.fSize, 
                                     fontFamily: 'Poppins',
                                     fontWeight: FontWeight.w500
                                   ),
                                 ),
                               ],
                             ),
                           );
                        }

                        return SingleChildScrollView(
                          padding: EdgeInsets.all(20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (smartParenting.isNotEmpty) ...[
                                _buildSectionHeader("Smart Parenting"),
                                SizedBox(height: 16.v),
                                ...smartParenting.map((item) => Padding(
                                  padding: EdgeInsets.only(bottom: 24.v), // More spacing
                                  child: _buildContentCard(context, item),
                                )),
                              ],

                              if (weekEndLetters.isNotEmpty) ...[
                                SizedBox(height: 10.v),
                                _buildSectionHeader("Week End Letter"),
                                SizedBox(height: 16.v),
                                ...weekEndLetters.map((item) => Padding(
                                  padding: EdgeInsets.only(bottom: 24.v),
                                  child: _buildContentCard(context, item),
                                )),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20.adaptSize, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Text(
            'Parent Hub',
            style: TextStyle(
              fontSize: 22.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 40.h),
        ],
      ),
    );
  }

  Widget _buildWeekDropdown(List<int> weeks) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 4.v),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: _selectedWeek,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
            isExpanded: true,
            hint: Text("Select Week", style: TextStyle(fontFamily: 'Poppins')),
            items: weeks.map((int week) {
              return DropdownMenuItem<int>(
                value: week,
                child: Text(
                  "Week $week",
                  style: TextStyle(fontSize: 14.fSize, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if(newValue != null && newValue != _selectedWeek) {
                setState(() {
                  _selectedWeek = newValue;
                  _loadContent();
                });
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.w600, fontFamily: 'Poppins', color: const Color(0xFF333333)),
        ),
        SizedBox(width: 10.h),
        Expanded(
          child: Divider(thickness: 1, color: Colors.black12),
        ),
      ],
    );
  }

  Widget _buildContentCard(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        final contentUrl = item['content_url'] as String? ?? "";
        if (contentUrl.toLowerCase().endsWith('.pdf')) {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => PDFViewerScreen(pdfPath: contentUrl, title: item['title'] ?? 'Document'))
          );
        } else {
           Navigator.push(
            context,
            MaterialPageRoute(
               builder: (context) => TeacherNoteDetailScreen(
                 note: {
                   'title': item['title'],
                   'date': DateTime.now(), 
                   'full_note': item['description'],
                   'detail_image_path': contentUrl.isNotEmpty ? contentUrl : item['thumbnail_path'], 
                 }
               ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Wrap content
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
                  child: Image.asset(
                    item['thumbnail_path'] ?? ImageConstant.imgParentingTips,
                    height: 220.v,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 220.v,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image, size: 50.adaptSize, color: Colors.grey[500]),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 10.v,
                  right: 10.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.v),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                    child: Text(
                      item['type'] ?? 'Update',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12.fSize, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? 'Title',
                    style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.bold, fontFamily: 'Poppins', height: 1.2),
                  ),
                  SizedBox(height: 8.v),
                  Text(
                    item['description'] ?? '',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.fSize, fontFamily: 'Poppins', height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 16.v),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF32B6F3),
                      ),
                      padding: EdgeInsets.all(8.h),
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16.adaptSize),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
