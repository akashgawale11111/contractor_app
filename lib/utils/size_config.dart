import 'package:flutter/material.dart';

/// Global responsive size utility.
///
/// Usage:
/// - Call SizeConfig.init(context) once per page (done globally in MaterialApp.builder)
/// - Use SizeConfig.wp(%) for width-based sizing
/// - Use SizeConfig.hp(%) for height-based sizing
/// - Use SizeConfig.sp(px) for font sizes scaled against a 375px base width
class SizeConfig {
  static late MediaQueryData _mq;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;

  static void init(BuildContext context) {
    _mq = MediaQuery.of(context);
    screenWidth = _mq.size.width;
    screenHeight = _mq.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  /// Width percentage of the screen (e.g., wp(10) == 10% of screen width)
  static double wp(double percent) => blockWidth * percent;

  /// Height percentage of the screen (e.g., hp(10) == 10% of screen height)
  static double hp(double percent) => blockHeight * percent;

  /// Responsive font size scaled to a 375px base width, with soft clamps via textScaleFactor in main.dart
  static double sp(double fontSize) {
    final scale = screenWidth / 375.0;
    return fontSize * scale;
  }
}


/// Constant sizes to be used in the app (paddings, gaps, rounded corners etc.)
class Sizes {
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p12 = 12.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;
  static const p32 = 32.0;
  static const p48 = 48.0;
  static const p64 = 64.0;
}

/// Constant gap widths
const w4 = SizedBox(width: Sizes.p4);
const gapW4 = SizedBox(width: Sizes.p4);
const gapW8 = SizedBox(width: Sizes.p8);
const gapW12 = SizedBox(width: Sizes.p12);
const gapW16 = SizedBox(width: Sizes.p16);
const gapW20 = SizedBox(width: Sizes.p20);
const gapW24 = SizedBox(width: Sizes.p24);
const gapW32 = SizedBox(width: Sizes.p32);
const gapW48 = SizedBox(width: Sizes.p48);
const gapW64 = SizedBox(width: Sizes.p64);
const gapW65 = SizedBox(width: 65);

/// Constant gap heights
const gapH4 = SizedBox(height: Sizes.p4);
const gapH8 = SizedBox(height: Sizes.p8);
const gapH12 = SizedBox(height: Sizes.p12);
const gapH16 = SizedBox(height: Sizes.p16);
const gapH20 = SizedBox(height: Sizes.p20);
const h20 = SizedBox(height: Sizes.p20);
const gapH24 = SizedBox(height: Sizes.p24);
const gapH32 = SizedBox(height: Sizes.p32);
const gapH48 = SizedBox(height: Sizes.p48);
const gapH64 = SizedBox(height: Sizes.p64);
