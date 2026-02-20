import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_export.dart';
import 'provider/preschool_gallery_provider.dart';
import '../../widgets/custom_image_view.dart';

// If PhotoView is needed for full screen, I might need a package, but I can use InteractiveViewer for now.

class PhotoGalleryScreen extends StatefulWidget {
  const PhotoGalleryScreen({Key? key}) : super(key: key);

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  @override
  void initState() {
    super.initState();
    // Load photos when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PreschoolGalleryProvider>().loadPhotos();
    });
  }

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
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              SizedBox(height: 20.v),
              _buildFilterTabs(context),
              SizedBox(height: 20.v),
              Expanded(
                child: _buildGalleryGrid(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.v),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Photo Gallery",
                style: TextStyle(
                  fontSize: 20.fSize,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 40.h), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context) {
    return Consumer<PreschoolGalleryProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 42.v,
          margin: EdgeInsets.symmetric(horizontal: 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.h),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              _buildTabButton(
                context, 
                title: "All Photos", 
                isSelected: provider.isAllPhotosSelected,
                onTap: () => provider.toggleFilter(true),
              ),
              _buildTabButton(
                context, 
                title: "My Child", 
                isSelected: !provider.isAllPhotosSelected,
                onTap: () => provider.toggleFilter(false),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(BuildContext context, {required String title, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : Colors.transparent,
            borderRadius: BorderRadius.circular(30.h),
            border: Border.all(
              color: isSelected ? Color(0xFF32B6F3) : Colors.transparent,
              width: 2.h,
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Color(0xFF32B6F3) : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(BuildContext context) {
    return Consumer<PreschoolGalleryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (provider.displayedPhotos.isEmpty) {
          return Center(
            child: Text(
              "No photos available",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16.fSize,
                color: Colors.grey,
              ),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: GridView.builder(
            itemCount: provider.displayedPhotos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14.h,
              mainAxisSpacing: 14.v,
              childAspectRatio: 0.85, // Adjusted for title and button
            ),
            itemBuilder: (context, index) {
              final photo = provider.displayedPhotos[index];
              return _buildPhotoCard(context, photo, provider);
            },
          ),
        );
      },
    );
  }

  Widget _buildPhotoCard(BuildContext context, Map<String, dynamic> photo, PreschoolGalleryProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openFullScreen(context, photo['image_path']),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.h)),
                child: CustomImageView(
                  imagePath: photo['image_path'],
                  fit: BoxFit.cover,
                  // Placeholder handling within CustomImageView or use native errorBuilder
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    photo['title'] ?? "Photo",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.fSize,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => provider.saveImageToDevice(photo['image_path'], context),
                  child: Padding(
                    padding: EdgeInsets.all(4.h),
                    child: Icon(
                      Icons.file_download,
                      size: 20.adaptSize,
                      color: Color(0xFF32B6F3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreen(BuildContext context, String? imagePath) {
    if (imagePath == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: InteractiveViewer(
              child: CustomImageView(
                imagePath: imagePath,
                fit: BoxFit.contain,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

