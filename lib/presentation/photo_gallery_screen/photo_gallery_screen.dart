import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  bool isAllPhotos = true;

  final List<String> images = [
    "https://placehold.co/300x200",
    "https://placehold.co/300x200",
    "https://placehold.co/300x200",
    "https://placehold.co/300x200",
    "https://placehold.co/300x200",
    "https://placehold.co/300x200",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgSelectProgramBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 48.v, bottom: 48.v),
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
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Photo Gallery",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// TABS
              Container(
                height: 42,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Row(
                  children: [

                    /// ALL PHOTOS
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAllPhotos = true;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isAllPhotos
                                  ? const Color(0xFF32B6F3)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            "All photos",
                            style: TextStyle(
                              color: isAllPhotos ? const Color(0xFF32B6F3) : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// MY CHILD
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAllPhotos = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isAllPhotos
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: !isAllPhotos
                                    ? const Color(0xFF32B6F3)
                                    : Colors.transparent,
                                width: 2),
                          ),
                          child: Text(
                            "My Child",
                            style: TextStyle(
                              color: !isAllPhotos ? const Color(0xFF32B6F3) : Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// GRID
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(color: Colors.grey[300], child: Icon(Icons.error));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
