import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/select_program_provider.dart';

class SelectProgramScreen extends StatefulWidget {
  const SelectProgramScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SelectProgramProvider(),
      child: const SelectProgramScreen(),
    );
  }

  @override
  State<SelectProgramScreen> createState() => _SelectProgramScreenState();
}

class _SelectProgramScreenState extends State<SelectProgramScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(ImageConstant.imgSelectProgramBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 48.v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeaderSection(),
                SizedBox(height: 12.v),
                _buildProgramList(),
                SizedBox(height: 24.v),
                _buildProceedButton(context),
                SizedBox(height: 16.v),
                Text(
                  'Bluestone International Preschool',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF808080),
                    fontSize: 14.fSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgButterfly,
          height: 120.adaptSize,
          width: 120.adaptSize,
        ),
        SizedBox(height: 24.v),
        SizedBox(
          width: 358.h,
          child: Text(
            'Choose Your Child’s Program',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.v),
        SizedBox(
          width: 358.h,
          child: Text(
            'Embark on a Journey of Discovery!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF808080),
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgramList() {
    return Consumer<SelectProgramProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildProgramCard(
                    id: 1,
                    title: 'NESTLERS',
                    subtitle: 'Playgroup (2 - 3 yrs)',
                    description: 'First steps into a world of sensory play',
                    color: const Color(0xFFBCE4CC),
                    iconPath: ImageConstant.imgTeddy,
                    isSelected: provider.selectedProgramId == 1,
                    onTap: () => provider.onProgramSelected(1),
                  ),
                ),
                SizedBox(width: 10.h),
                Expanded(
                  child: _buildProgramCard(
                    id: 2,
                    title: 'BAMBINO',
                    subtitle: 'Playgroup (3 - 4 yrs)',
                    description: 'Build language, motor & social skills.',
                    color: const Color(0xFFF8C79F),
                    iconPath: ImageConstant.imgBlocks,
                    isSelected: provider.selectedProgramId == 2,
                    onTap: () => provider.onProgramSelected(2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.v),
            Row(
              children: [
                Expanded(
                  child: _buildProgramCard(
                    id: 3,
                    title: 'B JUNIOR',
                    subtitle: 'Playgroup (4 - 5 yrs)',
                    description: 'Foundation for reading, writing & numbers',
                    color: const Color(0xFFB6E4F3),
                    iconPath: ImageConstant.imgBook,
                    isSelected: provider.selectedProgramId == 3,
                    onTap: () => provider.onProgramSelected(3),
                  ),
                ),
                SizedBox(width: 10.h),
                Expanded(
                  child: _buildProgramCard(
                    id: 4,
                    title: 'B SENIOR',
                    subtitle: 'Playgroup (5 - 6 yrs)',
                    description: 'Kindergarten readiness & creative thinking',
                    color: const Color(0xFFD6CFF8),
                    iconPath: ImageConstant.imgBulb,
                    isSelected: provider.selectedProgramId == 4,
                    onTap: () => provider.onProgramSelected(4),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgramCard({
    required int id,
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minHeight: 180.v),
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.h),
          border: isSelected
              ? Border.all(color: Colors.blueAccent, width: 3)
              : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0x26000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.v),
            Text(
              subtitle,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 12.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 8.v),
            Text(
              description,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 12.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.v),
            Row(
              children: [
                CustomImageView(
                  imagePath: iconPath,
                  height: 40.adaptSize,
                  width: 40.adaptSize,
                ),
                SizedBox(width: 8.h),
                _buildExploreButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 2.v),
      decoration: ShapeDecoration(
        color: const Color(0xFF1E88E5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
      ),
      child: Text(
        'EXPLORE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.fSize,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
         context.read<SelectProgramProvider>().onProceedToLogin(context);
      },
      child: Container(
        width: double.infinity,
        height: 42.v,
        decoration: ShapeDecoration(
          color: const Color(0xFF32B6F3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Proceed to Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10.h),
            Icon(Icons.arrow_forward, color: Colors.white, size: 20.adaptSize),
          ],
        ),
      ),
    );
  }
}
