import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import 'provider/preschool_otp_provider.dart';

class PreschoolOtpScreen extends StatefulWidget {
  const PreschoolOtpScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PreschoolOtpProvider(),
      child: const PreschoolOtpScreen(),
    );
  }

  @override
  State<PreschoolOtpScreen> createState() => _PreschoolOtpScreenState();
}

class _PreschoolOtpScreenState extends State<PreschoolOtpScreen> {
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
            padding: EdgeInsets.only(top: 60.v),
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
    return Positioned(
      top: 40.v, 
      child: CustomImageView(
        imagePath: ImageConstant.imgBluestoneInternationalPreschoolLogo, // Logo as per design
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
          SizedBox(height: 260.v),
          Text(
            'Please enter the code sent to your Mobile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.v),
          // Lock Image
          Container(
            height: 160.adaptSize,
            width: 160.adaptSize,
            child: CustomImageView(
              imagePath: ImageConstant.imgLock, // Placeholder
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 10.v),
          Text(
            '+91 84XXXXXX76', // Static for now, can be dynamic later
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF808080),
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 28.v),
          // OTP Inputs
          _buildOtpInputRow(context),
          SizedBox(height: 20.v),
          _buildConfirmButton(context),
          SizedBox(height: 20.v),
          _buildTimerText(context),
          SizedBox(height: 40.v),
          _buildResendLink(context),
          SizedBox(height: 24.v),
        ],
      ),
    );
  }

  Widget _buildOtpInputRow(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.h),
              height: 72.v,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.h),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  controller: context.read<PreschoolOtpProvider>().otpControllers[index],
                  focusNode: context.read<PreschoolOtpProvider>().focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 24.fSize,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    context.read<PreschoolOtpProvider>().onOtpChanged(context, index, value);
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PreschoolOtpProvider>().onConfirmPressed(context);
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
              'Confirm',
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

  Widget _buildTimerText(BuildContext context) {
    return Consumer<PreschoolOtpProvider>(
      builder: (context, provider, child) {
        if (provider.isResendEnabled) {
          return SizedBox(); // Or "Resend Code" button
        }
        return Text(
          'Resend code in ${provider.secondsRemaining} seconds',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF32B6F3),
            fontSize: 12.fSize,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  Widget _buildResendLink(BuildContext context) {
    return Consumer<PreschoolOtpProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: provider.isResendEnabled ? () => provider.onResendPressed() : null,
          child: Text(
            'Didn’t receive the code? Resend',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: provider.isResendEnabled ? const Color(0xFF32B6F3) : const Color(0xFF808080),
              fontSize: 14.fSize,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      },
    );
  }
}
