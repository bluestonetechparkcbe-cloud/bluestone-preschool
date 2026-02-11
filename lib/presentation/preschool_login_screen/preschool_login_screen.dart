import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/preschool_login_provider.dart';

class PreschoolLoginScreen extends StatefulWidget {
  const PreschoolLoginScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolLoginProvider(),
      child: const PreschoolLoginScreen(),
    );
  }

  @override
  State<PreschoolLoginScreen> createState() => _PreschoolLoginScreenState();
}

class _PreschoolLoginScreenState extends State<PreschoolLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.5, 0),
            end: Alignment(0.5, 1),
            colors: [
              const Color(0xFFD9F2F7),
              const Color(0xFFF2F9FB),
              const Color(0xFFE8F0F2),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: 60.v, // Adjusted for status bar possibly? User had 260 but that seems huge for top padding if image is absolute
              // User used Stack with Positioned. Let's try to replicate standard Column layout if possible, or use Stack as requested.
              // User code had top padding 260, but also a Positioned image at top: 6.
              // The Positioned image was the "Butterfly/Logo" thing.
              // I'll use a Stack for the top part and then a Column for the rest.
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                _buildContent(context),
                _buildHeaderImage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    // User had Positioned(left: 5, top: 6, child: Container(width: 379... height: 253...))
    // matches "https://placehold.co/380x253"
    // We'll use imgButterfly here as a placeholder for the "Logo + Butterfly" composite if user doesn't have a dedicated one,
    // OR we use the logo. The user design shows Logo + Butterfly.
    // For now, let's use the logo and maybe the butterfly image if they separate them.
    // Given the user code uses ONE image, I'll use a placeholder or the logo.
    return Positioned(
      top: 40.v, // Adjust as needed
      child: CustomImageView(
        imagePath: ImageConstant.imgBluestoneInternationalPreschoolLogo, // Or placeholder
        height: 200.adaptSize,
        width: 300.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        children: [
          SizedBox(height: 260.v), // Space for the header image
          Text(
            'Welcome to Bluestone!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.v),
          // Boy Image
          Container(
            height: 180.adaptSize,
            width: 180.adaptSize,
            child: CustomImageView(
              imagePath: ImageConstant.imgBoyLogin,
              fit: BoxFit.contain, // Changed key to contain to show full image without cropping
            ),
          ),
          SizedBox(height: 10.v),
          Text(
            'Parent / Educator Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 28.v),
          // Input Section
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Phone number',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 6.v),
          _buildPhoneNumberInput(context),
          SizedBox(height: 20.v),
          _buildGetOTPButton(context),
          SizedBox(height: 20.v),
          _buildTermsSection(),
          SizedBox(height: 40.v), // Spacer
          _buildLoginAsEducatorLink(context),
          SizedBox(height: 24.v),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberInput(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 42.v,
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.h),
        border: Border.all(color: Colors.grey.shade300, width: 1), // Optional border
      ),
      child: Align(
         alignment: Alignment.centerLeft,
         // We should use a TextFormField here properly, but user code had a Text.
         // Ill use a TextField.
         child: TextField(
           controller: context.read<PreschoolLoginProvider>().phoneNumberController,
           decoration: InputDecoration(
             hintText: 'Enter your number',
             hintStyle: TextStyle(
                color: const Color(0xFF808080),
                fontSize: 14.fSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
             ),
             border: InputBorder.none,
             isDense: true,
             contentPadding: EdgeInsets.zero,
           ),
           keyboardType: TextInputType.phone,
           style: TextStyle(
             color: Colors.black,
             fontSize: 14.fSize,
             fontFamily: 'Poppins',
             fontWeight: FontWeight.w500,
           ),
         ),
      ),
    );
  }

  Widget _buildGetOTPButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PreschoolLoginProvider>().onGetOTPPressed(context);
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
              'Get OTP',
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

  Widget _buildTermsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Checkbox placeholder
        Container(
          width: 20.adaptSize,
          height: 20.adaptSize,
          decoration: BoxDecoration(
             border: Border.all(color: Colors.grey),
             borderRadius: BorderRadius.circular(4.h),
          ),
          child: Icon(Icons.check, size: 16.adaptSize, color: const Color(0xFF32B6F3)), // Assume checked or implement toggle
        ),
        SizedBox(width: 4.h),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'I agree with ',
                style: TextStyle(
                  color: const Color(0xFF808080),
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  color: const Color(0xFF32B6F3),
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: ' and ',
                style: TextStyle(
                  color: const Color(0xFF808080),
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextSpan(
                text: 'T&C',
                style: TextStyle(
                  color: const Color(0xFF32B6F3),
                  fontSize: 12.fSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoginAsEducatorLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PreschoolLoginProvider>().onLoginAsEducatorPressed(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgLoginEducatorIcon,
            height: 16.adaptSize,
            width: 16.adaptSize,
          ),
          SizedBox(width: 8.h),
          Text(
            'Login as Educator',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
