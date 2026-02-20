import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import '../../db_helper.dart'; 
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return const RewardsScreen();
  }

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  int _selectedTab = 0; // 0: New Achievements, 1: My Sticker Book
  String _selectedCategory = "All";
  // Hardcoded email for now, in real app usage get from provider/session
  final String _parentEmail = "lavanyanbalagan@gmail.com"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: SizeUtils.height,
        decoration: BoxDecoration(
          color: appTheme.whiteCustom,
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgUpdatesBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _header(context),
              SizedBox(height: 12.v),
              _tabBar(),
              SizedBox(height: 12.v),
              _categoryChips(), // Cleaned up structure: Chips commonly useful for both or just top? Keeping visible for both or just new? Request says "Keep Horizontal Filter list" implies global or per tab. Let's keep it above list.
              SizedBox(height: 12.v),
              Expanded(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.v),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 20.adaptSize, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text(
            "Student Achievements", // Rename header? Request says "Rename them internally..." for tabs. Header "Maintain 'Offers'..." title? Request: "Maintain the 'Offers' and 'Claimed offers' toggle... Rename them internally to 'New Achievements' and 'My Sticker Book'". Header probably "Achievements" or keep "Rewards"? Let's update to "Achievements" to match context.
            style: TextStyle(
              fontSize: 20.fSize,
              fontWeight: FontWeight.w700,
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _tabItem("New Achievements", 0),
          _tabItem("My Sticker Book", 1),
        ],
      ),
    );
  }

  Widget _tabItem(String text, int index) {
    bool selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
            _selectedCategory = "All"; // Reset filter on tab switch? Or keep? Reset seems cleaner.
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.v),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF32B6F3) : Colors.transparent,
            borderRadius: BorderRadius.circular(30.h),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13.fSize, // Adjusted for longer text
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChips() {
    List<String> categories = ["All", "Academic", "Social", "Creative"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Row(
        children: categories.map((cat) {
            String? iconPath;
            if(cat == "Academic") iconPath = ImageConstant.imgIconApps; // Placeholder icons
            if(cat == "Social") iconPath = ImageConstant.imgIconShopping;
            if(cat == "Creative") iconPath = ImageConstant.imgIconWellness;
            // Use existing constants or similar logical mapping if exact icons aren't provided.
            // Using logic to pick icon based on name if available, else null
            
            return CategoryChip(
              text: cat,
              // iconPath: iconPath, // Optional: hide icons if not matching new categories perfectly or use generic
              selected: _selectedCategory == cat,
              onTap: () {
                setState(() {
                  _selectedCategory = cat;
                });
              },
            );
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    bool isClaimedTab = _selectedTab == 1;
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DBHelper.getAchievements(_parentEmail, isClaimed: isClaimedTab),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        
        final allItems = snapshot.data ?? [];
        
        // Apply Filter
        final filteredItems = _selectedCategory == "All" 
            ? allItems 
            : allItems.where((item) => item['category'] == _selectedCategory).toList();

        if (filteredItems.isEmpty) {
          return Center(
            child: Text(
              isClaimedTab ? "No earned stickers yet!" : "No new achievements!",
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16.fSize, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 48.v, top: 0),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            if (isClaimedTab) {
              return _buildClaimedCard(item, key: ValueKey(item['id']));
            } else {
              return _buildOfferCard(item, key: ValueKey(item['id']));
            }
          },
        );
      },
    );
  }

  Widget _buildOfferCard(Map<String, dynamic> item, {Key? key}) {
    return RewardCard(
      key: key,
      title: item['title'] ?? "",
      description: item['description'] ?? "",
      imagePath: item['image_path'] ?? "",
      category: item['category'] ?? "",
      onClaim: () async {
        bool success = await DBHelper.claimAchievement(item['id']);
        if (success) {
          setState(() {}); // Refresh UI
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Achievement Claimed! Added to Sticker Book."))
          );
        }
      },
    );
  }

  Widget _buildClaimedCard(Map<String, dynamic> item, {Key? key}) {
    return Container(
      key: key,
      margin: EdgeInsets.only(bottom: 16.v),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.h),
                child: Image.asset(
                  item['image_path'] ?? ImageConstant.imgRewardGiva,
                  height: 80.adaptSize,
                  width: 80.adaptSize,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                     return Container(
                       height: 80.adaptSize,
                       width: 80.adaptSize,
                       color: Colors.grey[200],
                       child: Icon(Icons.broken_image, color: Colors.grey),
                     );
                  },
                ),
              ),
              SizedBox(width: 16.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'] ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.fSize,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4.v),
                    Text(
                      item['description'] ?? "",
                      style: TextStyle(
                        fontSize: 13.fSize,
                        fontFamily: 'Poppins',
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.v),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.v),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                         item['category'] ?? "General",
                         style: TextStyle(fontSize: 10.fSize, color: Colors.blue, fontFamily: 'Poppins'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.v),
          // Certificate Button
           SizedBox(
             width: double.infinity,
             child: OutlinedButton.icon(
                onPressed: () {
                  _showCertificateDialog(context, item);
                },
                icon: Icon(Icons.verified_outlined, size: 18.adaptSize, color: const Color(0xFF32B6F3)),
                label: Text(
                  "View Certificate",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.fSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF32B6F3),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF32B6F3)),
                  padding: EdgeInsets.symmetric(vertical: 10.v),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
                ),
             ),
           ),
        ],
      ),
    );
  }

  void _showCertificateDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.h),
            side: const BorderSide(color: Color(0xFFFFD700), width: 4), // Gold Border
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.h),
              border: Border.all(color: const Color(0xFFFFD700), width: 3),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon / Header
                Icon(Icons.workspace_premium, size: 48.adaptSize, color: const Color(0xFFFFD700)),
                SizedBox(height: 8.v),
                Text(
                  "Certificate of Achievement",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18.fSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.v),
                
                // Child Name
                Text(
                  "This certifies that",
                  style: TextStyle(fontSize: 12.fSize, fontFamily: 'Poppins', color: Colors.grey),
                ),
                SizedBox(height: 4.v),
                Text(
                  "Lavanya A",
                  style: TextStyle(
                    fontFamily: 'GreatVibes', // Or Script font if available, else Poppins italic
                    fontSize: 24.fSize,
                    fontWeight: FontWeight.w600, // Regular for script usually
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF32B6F3),
                  ),
                ),
                SizedBox(height: 16.v),

                // Achievement Details
                Text(
                  "has successfully earned the badge",
                  style: TextStyle(fontSize: 12.fSize, fontFamily: 'Poppins', color: Colors.grey),
                ),
                SizedBox(height: 12.v),
                
                // Badge Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.h),
                  child: Image.asset( // Specifically using Image.asset as requested for asset paths
                    item['image_path'] ?? "",
                    height: 100.adaptSize,
                    width: 100.adaptSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, size: 50.adaptSize, color: Colors.grey);
                    },
                  ),
                ),
                SizedBox(height: 12.v),
                Text(
                  item['title'] ?? "Achievement",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.v),
                Text(
                  "Earned on ${item['date_earned']?.toString().split(' ')[0] ?? 'Today'}",
                  style: TextStyle(fontSize: 11.fSize, fontFamily: 'Poppins', color: Colors.grey),
                ),

                SizedBox(height: 24.v),
                
                // Download Button
                ElevatedButton.icon(
                  onPressed: () {
                     _generatePdf(context, item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF32B6F3),
                     shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                  ),
                  icon: Icon(Icons.download, color: Colors.white, size: 16.adaptSize),
                  label: Text("Download as PDF", style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _generatePdf(BuildContext context, Map<String, dynamic> item) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Preparing Certificate...")),
    );

    try {
      final pdf = pw.Document();
      
      // Load Image Safely with Try-Catch
      pw.MemoryImage? image;
      try {
        if (item['image_path'] != null && item['image_path'].isNotEmpty) {
           // Verify if it's an asset path
           final imageBytes = await rootBundle.load(item['image_path']);
           image = pw.MemoryImage(imageBytes.buffer.asUint8List());
        }
      } catch (e) {
        print("PDF Image Load Error: $e");
        // Proceed without image
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.amber, width: 4),
              ),
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                   pw.Text(
                    "Bluestone Preschool",
                    style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.blue),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    "Certificate of Achievement",
                    style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text("Awarded to", style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "Lavanya A", 
                    style: pw.TextStyle(fontSize: 32, fontStyle: pw.FontStyle.italic, color: PdfColors.blue),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text("For earning the badge", style: const pw.TextStyle(fontSize: 18, color: PdfColors.grey)),
                  pw.SizedBox(height: 10),
                  pw.Text(item['title'] ?? "Achievement", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 30),
                  if (image != null)
                    pw.Image(image, width: 150, height: 150)
                  else 
                    pw.Text("(Badge Image Not Available)", style: const pw.TextStyle(color: PdfColors.grey)),
                  pw.SizedBox(height: 20),
                  pw.Text("Date: ${item['date_earned']?.toString().split(' ')[0] ?? 'Today'}", style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey)),
                ],
              ),
            );
          },
        ),
      );

      // Use Printing package to show the PDF preview/print/share dialog
      // This handles permissions automatically for the share sheet
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Certificate_${item['title'].toString().replaceAll(' ', '_')}',
      );

    } catch (e) {
      print("PDF Generation Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error generating PDF: $e")),
      );
    }
  }
}

/// ------------------ REUSABLE CARD ------------------

class RewardCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final String category;
  final VoidCallback onClaim;

  const RewardCard({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.category,
    required this.onClaim,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.v),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.h),
            child: Image.asset(
              imagePath.isNotEmpty ? imagePath : ImageConstant.imgRewardGiva,
              height: 120.adaptSize,
              width: 120.adaptSize,
              fit: BoxFit.cover,
               errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120.adaptSize,
                    width: 120.adaptSize,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey),
                  );
               },
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.fSize,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4.v),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.fSize,
                    fontFamily: 'Poppins',
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.v),
                Text(
                  category,
                   style: TextStyle(
                    fontSize: 11.fSize,
                    fontFamily: 'Poppins',
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 8.v),
                SizedBox(
                  height: 32.v,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF32B6F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.h),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onClaim,
                    child: Text(
                      "Claim",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.fSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------ CHIP ------------------

class CategoryChip extends StatelessWidget {
  final String text;
  final String? iconPath;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    Key? key,
    required this.text,
    this.iconPath,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.v),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF32B6F3) : Colors.white,
          borderRadius: BorderRadius.circular(12.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconPath != null) ...[
              CustomImageView(
                imagePath: iconPath,
                height: 16.adaptSize,
                width: 16.adaptSize,
                color: selected ? Colors.white : const Color(0xFFFF2D7A),
              ),
              SizedBox(width: 6.h),
            ],
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 13.fSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
