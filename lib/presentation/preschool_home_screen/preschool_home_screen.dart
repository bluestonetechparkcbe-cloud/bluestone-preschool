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
      } else {
        // Fallback for testing or if accessed directly (though logic requires email)
        // You might want to handle this case, e.g., redirect to login
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE0B2), Color(0xFFAED581)], // Soft Sunset to Grass Green
            stops: [0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Consumer<PreschoolHomeProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              return Stack(
                children: [
                   // Background Decorations
                   _buildBackgroundIcons(),
                   
                   Column(
                     children: [
                       _buildTopBar(context, provider),

                       Expanded(
                         child: SingleChildScrollView(
                           child: SizedBox(
                             height: 1100.v, // Ensure enough scroll space for the winding path
                             width: double.infinity,
                             child: Stack(
                               children: [
                                 // The Winding Path
                                 Positioned.fill(
                                   child: CustomPaint(
                                     painter: CurvedPathPainter(),
                                   ),
                                 ),
                                 
                                 // Speech Bubble Greeting
                                 Positioned(
                                   top: 20.v,
                                   left: 40.h,
                                   right: 40.h,
                                   child: _buildSpeechBubble(),
                                 ),

                                 // Node 1: Quest & Play (Castle) - Left Side
                                 Positioned(
                                   top: 150.v,
                                   left: 20.h,
                                   child: _buildIslandNode(
                                      context, provider,
                                      title: "Quest & Play",
                                      imagePath: ImageConstant.imgCastle, // Use placeholder or existing
                                      labelColor: Colors.pinkAccent,
                                      onTap: () {},
                                      isLeft: true,
                                   ),
                                 ),
                                 
                                 // Decoration: Rocket near Castle
                                 Positioned(
                                   top: 130.v,
                                   left: 140.h,
                                   child: CustomImageView(imagePath: ImageConstant.imgRocket, height: 40.v, width: 40.h),
                                 ),

                                 // Node 2: Discover & Learn (Tree) - Right Side
                                 Positioned(
                                   top: 350.v,
                                   right: 20.h,
                                   child: _buildIslandNode(
                                      context, provider,
                                      title: "Discover & Learn",
                                      imagePath: ImageConstant.imgTree, 
                                      labelColor: Colors.green,
                                      onTap: () {},
                                      isLeft: false,
                                   ),
                                 ),
                                 
                                 // Decoration: Gamepad somewhere
                                 Positioned(
                                   top: 300.v,
                                   left: 100.h,
                                   child: CustomImageView(imagePath: ImageConstant.imgGamepad, height: 30.v, width: 30.h),
                                 ),

                                 // Node 3: Creative Cove (Palette) - Left Side
                                 Positioned(
                                    top: 550.v,
                                    left: 20.h,
                                    child: _buildIslandNode(
                                      context, provider,
                                      title: "Creative Cove",
                                      imagePath: ImageConstant.imgPalette, 
                                      labelColor: Colors.blueAccent,
                                      onTap: () {},
                                      isLeft: true,
                                   ),
                                 ),
                                 
                                 // Decoration: Bubbles/Stars
                                 Positioned(
                                   top: 530.v,
                                   right: 50.h,
                                   child: Text("Yay!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.fSize)),
                                 ),

                                 // Node 4: Discovery Peak (Mountain) - Right Side
                                 Positioned(
                                    top: 750.v,
                                    right: 20.h,
                                    child: _buildIslandNode(
                                      context, provider,
                                      title: "Discovery Peak",
                                      imagePath: ImageConstant.imgMountain, 
                                      labelColor: Colors.orange,
                                      onTap: () {},
                                      isLeft: false,
                                   ),
                                 ),

                                 // Add Student Button (Bottom Center)
                                 Positioned(
                                   bottom: 50.v,
                                   left: 0,
                                   right: 0,
                                   child: Center(
                                     child: ElevatedButton.icon(
                                       onPressed: () => _showAddStudentSheet(context, provider),
                                       icon: Icon(Icons.person_add, color: Colors.white),
                                       label: Text("Add Student", style: TextStyle(color: Colors.white, fontSize: 16.fSize)),
                                       style: ElevatedButton.styleFrom(
                                         backgroundColor: Colors.pink,
                                         foregroundColor: Colors.white,
                                         padding: EdgeInsets.symmetric(horizontal: 40.h, vertical: 15.v),
                                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                         elevation: 5,
                                       ),
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ),
                       ),
                       
                       // Bottom Progress Bar
                       _buildProgressBar(context, provider),
                     ],
                   )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSpeechBubble() { // New Speech Bubble
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.v),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.cyan, width: 2),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Column(
        children: [
          Text(
            "Hi, Little Explorer!", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.fSize, color: Colors.black87)
          ),
          Text(
            "What adventure awaits?", 
            style: TextStyle(fontSize: 16.fSize, color: Colors.black54)
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundIcons() {
    return Stack(
      children: [
        Positioned(top: 80.v, left: -20.h, child: Icon(Icons.cloud, size: 100.h, color: Colors.white.withOpacity(0.6))),
        Positioned(top: 120.v, right: -30.h, child: Icon(Icons.cloud, size: 120.h, color: Colors.white.withOpacity(0.5))),
        Positioned(bottom: 300.v, left: 30.h, child: Icon(Icons.eco, size: 30.h, color: Colors.green.withOpacity(0.4))), // Little tuft of grass
        Positioned(bottom: 400.v, right: 60.h, child: Icon(Icons.wb_sunny, size: 30.h, color: Colors.yellow.withOpacity(0.4))),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context, PreschoolHomeProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
             padding: EdgeInsets.all(5),
             decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
             child: CustomImageView(imagePath: ImageConstant.imgButterfly, height: 40.v, width: 40.h),
          ),
          GestureDetector(
            onTap: () {
              if (provider.isVerified) {
                context.read<PreschoolHomeProvider>().onParentCornerPressed(context);
              } else {
                 _showLockedSheet(context);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.v),
              decoration: BoxDecoration(
                color: Color(0xFF2979FF), // Stronger Blue
                borderRadius: BorderRadius.circular(30), // Pill shape
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  if (!provider.isVerified) ...[
                     Icon(Icons.lock, size: 18.h, color: Colors.white),
                     SizedBox(width: 5.h),
                  ],
                  Text("Parent Corner", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslandNode(BuildContext context, PreschoolHomeProvider provider, {
    required String title, 
    required String imagePath, 
    required Color labelColor,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return GestureDetector(
      onTap: () {
        if (provider.isVerified) onTap();
        else _showLockedSheet(context);
      },
      child: Column(
        children: [
          // Illustration illustration
          Stack(
            alignment: Alignment.center,
            children: [
               // If we don't have illustration yet, use a colored circle as placeholder
               Container(
                 width: 140.h,
                 height: 140.v,
                 // Placeholder decoration until real asset
                 decoration: BoxDecoration(
                   // color: Colors.white.withOpacity(0.2), 
                   // shape: BoxShape.circle 
                 ), 
                 child: CustomImageView(
                    imagePath: imagePath,
                    height: 140.v,
                    width: 140.h,
                    fit: BoxFit.contain,
                    // fallback so we see something if asset missing
                    // alignment: Alignment.center, 
                 ),
               ),
               
               if (!provider.isVerified)
                 Icon(Icons.lock, size: 50.h, color: Colors.black54), // Direct overlay
            ],
          ),
          
          SizedBox(height: 5.v),
          
          // Bubbly Label
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.v),
            decoration: BoxDecoration(
              color: labelColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 2))],
            ),
            child: Text(
              title, 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.fSize, fontFamily: 'Comic Sans MS')
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, PreschoolHomeProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("My Daily Journey", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.fSize, color: Colors.blue[800])),
                 SizedBox(height: 5.v),
                 ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: provider.isVerified ? provider.studentProgress / 100 : 0,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      minHeight: 12.v,
                    ),
                 ),
               ],
            ),
          ),
          SizedBox(width: 15.h),
          Text(
            provider.isVerified ? "${provider.studentProgress.toStringAsFixed(1)}%" : "Locked", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.fSize, color: Colors.blue[800])
          ),
          if (provider.isVerified) ...[
             SizedBox(width: 5.h),
             Icon(Icons.card_giftcard, color: Colors.orange, size: 24.h) // Treasure chest placeholder
          ]
        ],
      ),
    );
  }
  void _showLockedSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
        ),
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_person, size: 60.h, color: Colors.orange),
            SizedBox(height: 15.v),
            Text(
              'Unlock Your Adventure!',
              style: TextStyle(fontSize: 22.fSize, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 10.v),
            Text(
              'Enroll effectively at your nearest Bluestone Pre-School to access these magical worlds.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.fSize, color: Colors.grey[700]),
            ),
            SizedBox(height: 25.v),
            ElevatedButton(
              onPressed: () {
                 Navigator.pushNamedAndRemoveUntil(context, AppRoutes.selectProgramScreen, (route) => false);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddStudentSheet(BuildContext context, PreschoolHomeProvider provider) {
    final nameController = TextEditingController();
    DateTime? selectedDate;
    String selectedGender = "Male"; // Default

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20.h, right: 20.h, top: 20.v
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Add Student", style: TextStyle(fontSize: 20.fSize, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Student Name"),
                  ),
                  SizedBox(height: 10.v),
                  ListTile(
                    title: Text(selectedDate == null ? "Select DOB" : "${selectedDate!.toLocal()}".split(' ')[0]),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                  ),
                  Row(
                    children: [
                      Text("Gender: "),
                      Radio<String>(
                        value: "Male",
                        groupValue: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v!),
                      ),
                      Text("Male"),
                      Radio<String>(
                        value: "Female",
                        groupValue: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v!),
                      ),
                      Text("Female"),
                    ],
                  ),
                  SizedBox(height: 20.v),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                         if (nameController.text.isNotEmpty && selectedDate != null) {
                            bool success = await provider.addNewStudent(nameController.text, selectedDate!, selectedGender);
                            if (success) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Student Added")));
                            } else {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add student")));
                            }
                         } else {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
                         }
                      },
                      child: Text("Save Student"),
                    ),
                  ),
                  SizedBox(height: 20.v),
                ],
              ),
            );
          }
        );
      }
    );
  }
}

class CurvedPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke;

    double dashWidth = 10;
    double dashSpace = 8;
    double startY = 30; // Start below the first node approx
    double endY = size.height - 50;

    while (startY < endY) {
      canvas.drawLine(
        Offset(size.width / 2, startY), 
        Offset(size.width / 2, startY + dashWidth), 
        paint
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
