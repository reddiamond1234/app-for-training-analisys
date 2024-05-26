import 'package:flutter/material.dart';

import 'colors.dart';

abstract class BVTextStyles {
  static TextStyle get headingEnter => const TextStyle(
        fontSize: 30,
        color: BVColors.dark,
        height: 1.033,
      );

  static TextStyle get heading01 => const TextStyle(
        fontSize: 24,
        decoration: TextDecoration.none,
        fontFamily: 'Manrope-SemiBold',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 24,
        letterSpacing: 0,
      );

  static TextStyle get heading02 => const TextStyle(
        fontSize: 20,
        decoration: TextDecoration.none,
        fontFamily: 'Manrope-SemiBold',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 20,
        letterSpacing: 0,
      );

  static TextStyle get bold => const TextStyle(
        fontSize: 18,
        decoration: TextDecoration.none,
        fontFamily: 'Manrope-SemiBold',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 18 / 18,
        letterSpacing: 0,
      );

  static TextStyle get name => const TextStyle(
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 18 / 18,
        letterSpacing: 1.08,
      );

  static TextStyle get text => const TextStyle(
        color: BVColors.text,
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 1.16,
        letterSpacing: 0,
      );

  static TextStyle get textUnderline => const TextStyle(
        fontSize: 16,
        decoration: TextDecoration.underline,
        fontFamily: 'Manrope-Regular',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 16 / 16,
        letterSpacing: 0,
      );

  static TextStyle get textBold => const TextStyle(
        fontSize: 16,
        decoration: TextDecoration.none,
        fontFamily: 'Manrope-SemiBold',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 16 / 16,
        letterSpacing: 0,
      );

  static TextStyle get info => const TextStyle(
        fontSize: 14,
        decoration: TextDecoration.none,
        fontFamily: 'Manrope-Regular',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 15.62 / 14,
        letterSpacing: 0,
      );

  static TextStyle get infoSmall => const TextStyle(
        fontSize: 13,
        decoration: TextDecoration.none,
        fontFamily: 'Manrope-Regular',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 15.21 / 13,
        letterSpacing: 0,
      );

  static TextStyle get infoSmallUnderline => const TextStyle(
        fontSize: 13,
        decoration: TextDecoration.underline,
        fontFamily: 'Manrope-Regular',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 13 / 13,
        letterSpacing: 0,
      );

  static TextStyle get infoSmallBold => const TextStyle(
        fontSize: 13,
        decoration: TextDecoration.none,
        fontFamily: 'Manrope-Bold',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 15.21 / 13,
        letterSpacing: 0,
      );

  static TextStyle get primaryButtonStyle => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w600,
      );

  static TextStyle get secondaryButtonStyle => const TextStyle(
        fontSize: 16,
        fontFamily: 'Manrope',
        fontWeight: FontWeight.w400,
      );

  // NEW
  static TextStyle get latoBold => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get latoHeading => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: BVColors.text,
      );
}
