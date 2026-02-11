import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Display Styles
  // Large text styles typically used for headers and hero elements

  TextStyle get display40BoldPoppins => TextStyle(
    fontSize: 40.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: appTheme.whiteA700,
  );

  // Headline Styles
  // Medium-large text styles for section headers

  TextStyle get headline24BoldPoppins => TextStyle(
    fontSize: 24.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: appTheme.whiteCustom,
  );

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title22SemiBoldPoppins => TextStyle(
    fontSize: 22.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: appTheme.yellowA700,
  );

  TextStyle get title20RegularRoboto => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );

  TextStyle get title20BoldPoppins => TextStyle(
    fontSize: 20.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: appTheme.blackCustom,
  );

  TextStyle get title18BoldPoppins => TextStyle(
    fontSize: 18.fSize,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    color: appTheme.blackCustom,
  );

  TextStyle get title16MediumPoppins => TextStyle(
    fontSize: 16.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: appTheme.gray_100,
  );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body15SemiBoldPoppins => TextStyle(
    fontSize: 15.fSize,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    color: appTheme.whiteCustom,
  );

  TextStyle get body14MediumPoppins => TextStyle(
    fontSize: 14.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: appTheme.whiteA700,
  );

  TextStyle get body13MediumPoppins => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    color: appTheme.gray_100,
  );

  TextStyle get body13RegularPoppins => TextStyle(
    fontSize: 13.fSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    color: appTheme.gray_600,
  );
}
