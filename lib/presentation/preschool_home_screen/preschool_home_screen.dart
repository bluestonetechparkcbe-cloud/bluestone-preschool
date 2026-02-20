import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/preschool_home_provider.dart';

class PreschoolHomeScreen extends StatefulWidget {
  const PreschoolHomeScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolHomeProvider(),
      child: const PreschoolHomeScreen(),
    );
  }

  @override
  State<PreschoolHomeScreen> createState() => _PreschoolHomeScreenState();
}

class _PreschoolHomeScreenState extends State<PreschoolHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['email'] != null) {
        context.read<PreschoolHomeProvider>().init(args['email']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            // 1. FIXED BACKGROUND
            Positioned.fill(
              child: CustomImageView(
                imagePath: ImageConstant.imgHomeBackground,
                fit: BoxFit.fill,
              ),
            ),

            // 2. PRECISION ALIGNED ISLAND NODES
            // Island 1: Quest & Play
            _positionedNode(
              top: screenHeight * 0.32,
              left: screenWidth * 0.10,
              title: "Quest & Play",
              img: ImageConstant.imgCastle,
              color: Colors.pinkAccent,
            ),
            // Island 2: Discover & Learn
            _positionedNode(
              top: screenHeight * 0.46,
              right: screenWidth * 0.10,
              title: "Discover & Learn",
              img: ImageConstant.imgTree,
              color: Colors.green,
            ),
            // Island 3: Creative Cove
            _positionedNode(
              top: screenHeight * 0.60,
              left: screenWidth * 0.12,
              title: "Creative Cove",
              img: ImageConstant.imgPalette,
              color: Colors.blueAccent,
            ),
            // Island 4: Discovery Peak
            Consumer<PreschoolHomeProvider>(
              builder: (context, provider, _) {
                 bool isAdded = provider.studentName != null;
                 return _positionedNode(
                  top: screenHeight * 0.74,
                  right: screenWidth * 0.15,
                  title: "Discovery Peak",
                  img: ImageConstant.imgMountain,
                  color: Colors.orange,
                  isAdd: true,
                  isStudentAdded: isAdded,
                );
              },
            ),

            // 3. FIXED HUD OVERLAYS
            Positioned(
              top: 45.v,
              left: 0,
              right: 0,
              child: Consumer<PreschoolHomeProvider>(
                builder: (context, provider, child) => _buildTopBar(context, provider),
              ),
            ),
            
            // "Hi, Little Explorer" Card - Moved 20px down from clouds
            Positioned(
              top: 125.v, 
              left: 0,
              right: 0,
              child: Center(child: _buildSpeechBubble()),
            ),

            // 4. ROUNDED BOTTOM PROGRESS BAR (Manual Placement for rounded corners)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: Colors.white,
                  child: Consumer<PreschoolHomeProvider>(
                    builder: (context, provider, child) => _buildProgressBar(context, provider),
                  ),
                ),
              ),
            ),

            // Global Loading Indicator
            Consumer<PreschoolHomeProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Container(
                    color: Colors.black45,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _positionedNode({required double top, double? left, double? right, required String title, required String img, required Color color, bool isAdd = false, bool isStudentAdded = false}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Consumer<PreschoolHomeProvider>(
        builder: (ctx, provider, _) => _buildIslandNode(
          ctx, provider,
          title: title,
          imagePath: img,
          labelColor: color,
          showSmallAddIcon: isAdd,
          isStudentAdded: isStudentAdded,
          onTap: () {
            if (isStudentAdded) {
               showDialog(
                 context: context, 
                 builder: (c) => AlertDialog(
                   title: Text("Request Sent!"),
                   content: Text("Notification sent to school! Verification in progress."),
                   actions: [TextButton(onPressed: () => Navigator.pop(c), child: Text("OK"))],
                 )
               );
            } else if (isAdd) {
              _showAddStudentSheet(context, provider);
            } else {
              _showLockedSheet(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSpeechBubble() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan, width: 2),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Hi, Little Explorer!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.fSize, color: Colors.black87)),
          Text("What adventure awaits?", style: TextStyle(fontSize: 14.fSize, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, PreschoolHomeProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomImageView(imagePath: ImageConstant.imgButterfly, height: 40.v, width: 40.h),
          GestureDetector(
            onTap: () => provider.isVerified ? provider.onParentCornerPressed(context) : _showLockedSheet(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 8.v),
              decoration: BoxDecoration(
                color: const Color(0xFF2979FF),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  if (!provider.isVerified) Icon(Icons.lock, size: 16.h, color: Colors.white),
                  if (!provider.isVerified) SizedBox(width: 5.h),
                  Text(
                    "Parent Corner", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14.fSize)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslandNode(BuildContext context, PreschoolHomeProvider provider, {required String title, required String imagePath, required Color labelColor, required VoidCallback onTap, bool showSmallAddIcon = false, bool isStudentAdded = false}) {
    return GestureDetector(
      onTap: () {
        if (provider.isVerified) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Coming Soon")));
        } else {
          onTap(); // Use original callback if not verified (Locked or Add Student)
        }
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              CustomImageView(imagePath: imagePath, height: 90.v, width: 90.h, fit: BoxFit.contain),
              if (!provider.isVerified && !showSmallAddIcon && !isStudentAdded) Icon(Icons.lock, size: 35.h, color: Colors.black54),
              if (showSmallAddIcon && !isStudentAdded) Positioned(bottom: 0, right: -5, child: Icon(Icons.add_circle, color: Colors.pink, size: 28.h)),
              if (isStudentAdded) Positioned(bottom: 0, right: -5, child: Icon(Icons.check_circle, color: Colors.green, size: 28.h)),
            ],
          ),
          SizedBox(height: 5.v),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 4.v),
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, offset: const Offset(0, 2))],
            ),
            child: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.fSize)),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, PreschoolHomeProvider provider) {
    return Container(
      padding: EdgeInsets.all(15.h),
      decoration: const BoxDecoration(color: Colors.white), // Background handled by ClipRRect parent
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("My Daily Journey", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800], fontSize: 14.fSize)),
                SizedBox(height: 5.v),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: provider.isVerified ? provider.studentProgress / 100 : 0,
                    backgroundColor: Colors.grey[200],
                    minHeight: 10.v,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.h),
          Text(
            provider.isVerified ? "${provider.studentProgress.toStringAsFixed(0)}%" : "Locked",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800], fontSize: 14.fSize),
          ),
        ],
      ),
    );
  }

  void _showLockedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: EdgeInsets.all(30.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 60.h, color: Colors.orange),
            SizedBox(height: 20.v),
            Text(
              'Enroll at nearest Bluestone Pre-School to access this content',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.fSize, fontWeight: FontWeight.bold, fontFamily: 'Comic Sans MS'),
            ),
            SizedBox(height: 30.v),
            OutlinedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.preschoolLoginScreen, (route) => false),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.purple), shape: const StadiumBorder()),
              child: const Text("Log Out", style: TextStyle(color: Colors.purple)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStudentSheet(BuildContext context, PreschoolHomeProvider provider) {
    final TextEditingController nameController = TextEditingController();
    DateTime? selectedDate;
    String gender = "Male";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20.v,
              left: 30.h,
              right: 30.h,
              top: 30.v,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Student",
                  style: TextStyle(fontSize: 22.fSize, fontWeight: FontWeight.bold, fontFamily: 'Comic Sans MS'),
                ),
                SizedBox(height: 20.v),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Student Name", border: UnderlineInputBorder()),
                ),
                SizedBox(height: 20.v),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(selectedDate == null ? "Select DOB" : "${selectedDate!.toLocal()}".split(' ')[0]),
                  trailing: Icon(Icons.calendar_today, size: 24.h),
                  onTap: () async {
                    final picked = await showDatePicker(
                       context: context,
                       initialDate: DateTime.now(),
                       firstDate: DateTime(2015),
                       lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                ),
                SizedBox(height: 10.v),
                Row(
                  children: [
                    const Text("Gender: "),
                    Radio<String>(value: "Male", groupValue: gender, activeColor: Colors.purple, onChanged: (v) => setState(() => gender = v!)),
                    const Text("Male"),
                    SizedBox(width: 10.h),
                    Radio<String>(value: "Female", groupValue: gender, activeColor: Colors.purple, onChanged: (v) => setState(() => gender = v!)),
                    const Text("Female"),
                  ],
                ),
                SizedBox(height: 30.v),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                       if (nameController.text.isNotEmpty && selectedDate != null) {
                         bool success = await provider.addNewStudent(nameController.text, selectedDate!, gender);
                         if (success) {
                           Navigator.pop(context);
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success: Student Added!")));
                         } else {
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to add student")));
                         }
                       } else {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
                       }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.purple,
                      side: const BorderSide(color: Colors.purple),
                      minimumSize: const Size(280, 45),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: const Text("Save Student"),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}