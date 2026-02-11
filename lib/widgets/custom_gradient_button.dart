import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * A customizable button widget with gradient text styling and optional right icon.
 * 
 * This component provides a button with white background, shadow effect, rounded corners,
 * and gradient text. Supports optional right icon and customizable styling properties.
 * 
 * @param text - The button label text to display
 * @param onPressed - Callback function triggered when button is tapped
 * @param rightIcon - Optional image path for right-side icon
 * @param gradientColors - List of colors for text gradient effect
 * @param backgroundColor - Background color of the button
 * @param borderRadius - Corner radius value for button shape
 * @param width - Button width, uses flex-1 equivalent if not specified
 * @param shadowColor - Color of the drop shadow effect
 * @param shadowBlurRadius - Blur radius of the drop shadow
 * @param shadowOffset - Offset of the drop shadow
 * @param padding - Internal padding of the button content
 * @param margin - External margin around the button
 */
class CustomGradientButton extends StatelessWidget {
  CustomGradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.rightIcon,
    this.gradientColors,
    this.backgroundColor,
    this.borderRadius,
    required this.width,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.padding,
    this.margin,
  }) : super(key: key);

  /// The button label text to display
  final String text;

  /// Callback function triggered when button is tapped
  final VoidCallback? onPressed;

  /// Optional image path for right-side icon
  final String? rightIcon;

  /// List of colors for text gradient effect
  final List<Color>? gradientColors;

  /// Background color of the button
  final Color? backgroundColor;

  /// Corner radius value for button shape
  final double? borderRadius;

  /// Button width (required parameter)
  final double width;

  /// Color of the drop shadow effect
  final Color? shadowColor;

  /// Blur radius of the drop shadow
  final double? shadowBlurRadius;

  /// Offset of the drop shadow
  final Offset? shadowOffset;

  /// Internal padding of the button content
  final EdgeInsetsGeometry? padding;

  /// External margin around the button
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin ?? EdgeInsets.only(top: 28.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? appTheme.whiteCustom,
        borderRadius: BorderRadius.circular(borderRadius ?? 12.h),
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? Color(0x26000000),
            blurRadius: shadowBlurRadius ?? 24.h,
            offset: shadowOffset ?? Offset(0, 8.h),
          ),
        ],
      ),
      child: Material(
        color: appTheme.transparentCustom,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 12.h),
          child: Padding(
            padding:
                padding ??
                EdgeInsets.only(
                  top: 12.h,
                  bottom: 12.h,
                  left: 30.h,
                  right: 30.h,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGradientText(),
                if (rightIcon != null) ...[
                  SizedBox(width: 8.h),
                  CustomImageView(
                    imagePath: rightIcon!,
                    height: 20.h,
                    width: 20.h,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientText() {
    final colors =
        gradientColors ??
        [Color(0xFFFF2D7A), appTheme.pink_500, appTheme.orange_600];

    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: colors,
        stops: [0.0, 0.5, 1.0],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyleHelper.instance.body15SemiBoldPoppins.copyWith(
          height: 1.53,
        ),
      ),
    );
  }
}
