import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {

  const Colors();

  static const Color loginGradientStart = const Color(0xFFFF6347);
  static const Color loginGradientEnd = const Color(0xFFFF1493);



  static const Color signupGradientStart = const Color(0xFFFF5E3A);
  static const Color signupGradientEnd = const Color(0xFFFF9500);

  static const Color thirdGradientStart = const Color(0xFFFF8487);
  static const Color thirdGradientEnd = const Color(0xFFFFBD4A);

  static const Color firstGradientStart = const Color(0xFF836AE8);
  static const Color firstGradientEnd = const Color(0xFF2EB5E6);


  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [2.0, 1.0],
    begin: Alignment.center,
    end: Alignment.bottomCenter,
  );
  static const primaryGradient1 = const LinearGradient(
    colors: const [signupGradientStart, signupGradientEnd],
    stops: const [2.0, 1.0],
    begin: Alignment.center,
    end: Alignment.bottomCenter,
  );
}