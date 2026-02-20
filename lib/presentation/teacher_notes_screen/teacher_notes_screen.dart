import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import '../../db_helper.dart';
import 'teacher_note_detail_screen.dart';

class TeacherNotesScreen extends StatefulWidget {
  const TeacherNotesScreen({Key? key}) : super(key: key);

  @override
  State<TeacherNotesScreen> createState() => _TeacherNotesScreenState();
}

class _TeacherNotesScreenState extends State<TeacherNotesScreen> {
  // Hardcoded email for now
  final String _parentEmail = "lavanyanbalagan@gmail.com"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgUpdatesBg),
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

              /// NOTES LIST
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: DBHelper.getTeacherNotes(_parentEmail),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    
                    final allNotes = snapshot.data ?? [];
                    if (allNotes.isEmpty) {
                      return const Center(child: Text("No notes available."));
                    }

                    // Grouping Logic
                    final today = DateTime.now();
                    final todayStr = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
                    
                    List<Map<String, dynamic>> todayNotes = [];
                    List<Map<String, dynamic>> olderNotes = [];

                    for (var note in allNotes) {
                      final noteDate = note['date']?.toString().split(' ')[0] ?? "";
                      if (noteDate == todayStr) {
                        todayNotes.add(note);
                      } else {
                        olderNotes.add(note);
                      }
                    }

                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      children: [
                        // TODAY SECTION
                        if (todayNotes.isNotEmpty) ...[
                          _buildSectionHeader("TODAY"),
                          SizedBox(height: 16.v),
                          ...todayNotes.map((note) => Padding(
                            padding: EdgeInsets.only(bottom: 16.v),
                            child: TeacherNoteCard(
                              title: note['title'] ?? "",
                              description: note['summary'] ?? "",
                              imageUrl: note['illustration_path'] ?? "",
                              onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => TeacherNoteDetailScreen(note: note))
                                );
                              },
                            ),
                          )),
                        ],

                        // OLDER NOTES SECTION
                        if (olderNotes.isNotEmpty) ...[
                          SizedBox(height: 8.v),
                          _buildSectionHeader("OLDER"),
                          SizedBox(height: 16.v),
                           ...olderNotes.map((note) => Padding(
                            padding: EdgeInsets.only(bottom: 16.v),
                            child: TeacherNoteCard(
                              title: note['title'] ?? "",
                              description: note['summary'] ?? "",
                              imageUrl: note['illustration_path'] ?? "",
                              onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => TeacherNoteDetailScreen(note: note))
                                );
                              },
                            ),
                          )),
                        ]
                      ],
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

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.fSize, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
        SizedBox(width: 10.h),
        Expanded(
          child: Divider(thickness: 1, color: Colors.black26),
        ),
      ],
    );
  }
}

class TeacherNoteCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const TeacherNoteCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                    style: TextStyle(fontSize: 14.fSize, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                  ),
                  SizedBox(height: 6.v),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13.fSize, fontFamily: 'Poppins', height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            SizedBox(width: 10.h),

            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(10.h),
              child: Image.asset(
                imageUrl.isNotEmpty ? imageUrl : "assets/images/growing_independence.png", 
                height: 100.adaptSize,
                width: 100.adaptSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                   print("Error loading image: $imageUrl. Error: $error");
                   return Container(
                     width: 100.adaptSize,
                     height: 100.adaptSize,
                     color: Colors.grey[200],
                     child: Icon(Icons.broken_image, color: Colors.grey),
                   );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
