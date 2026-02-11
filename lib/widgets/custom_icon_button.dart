import 'package:flutter/material.dart';

import '../core/app_export.dart';
import './custom_image_view.dart';

/**
 * CustomIconButton - A reusable icon button component with customizable styling
 * 
 * Supports different background colors, border radius, padding, and sizes.
 * All icons are handled through CustomImageView for consistent image rendering.
 * 
 * @param onPressed - Callback function when button is tapped
 * @param iconPath - Path to the icon (SVG, PNG, network URL, etc.)
 * @param backgroundColor - Background color of the button
 * @param borderRadius - Border radius for rounded corners
 * @param padding - Internal padding around the icon
 * @param width - Width of the button
 * @param height - Height of the button
 * @param iconSize - Size of the icon inside the button
 */
class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.onPressed,
    required this.iconPath,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.iconSize,
  }) : super(key: key);

  /// Callback function triggered when the button is tapped
  final VoidCallback? onPressed;

  /// Path to the icon image (SVG, PNG, network URL, etc.)
  final String iconPath;

  /// Background color of the button
  final Color? backgroundColor;

  /// Border radius for rounded corners
  final double? borderRadius;

  /// Internal padding around the icon
  final EdgeInsetsGeometry? padding;

  /// Width of the button
  final double? width;

  /// Height of the button
  final double? height;

  /// Size of the icon inside the button
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width ?? 40.h,
        height: height ?? 40.h,
        padding: padding ?? EdgeInsets.all(10.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? appTheme.transparentCustom,
          borderRadius: BorderRadius.circular(borderRadius ?? 20.h),
        ),
        child: CustomImageView(
          imagePath: iconPath,
          height: iconSize ?? 20.h,
          width: iconSize ?? 20.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
