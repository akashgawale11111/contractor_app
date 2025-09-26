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
