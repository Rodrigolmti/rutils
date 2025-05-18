import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RUtilsInsets {
  RUtilsInsets._();

  static const double malibu = 8; //Color(0xFF76C6F3);
  static const double cottonCandy = 16; //Color(0xFFFFB1EE);
  static const double tradewind = 24; //Color(0xFF66ADA9);
  static const double ceriseRed = 32; //Color(0xFFDC2B56);
  static const double citron = 40; //Color(0xFFADB020);
  static const double jellyBean = 48; //Color(0xFF2B7393);
  static const double mangoTango = 56; //Color(0xFFE26D00);
  static const double violetEggplant = 64; //Color(0xFFB911A8);
  static const double purpleHearth = 72; //Color(0xFF5B20D9);
  static const double sandyBrown = 80; //Color(0xFFF4A256);
  static const double goldenFizz = 88; //Color(0xFFFBF33F);
  static const double lima = 96; //Color(0xFF6AD416);
}

class RUtilsCorners {
  RUtilsCorners._();

  static const double sm = 3;
  static const BorderRadius smBorder = BorderRadius.all(smRadius);
  static const Radius smRadius = Radius.circular(sm);

  static const double med = 5;
  static const BorderRadius medBorder = BorderRadius.all(medRadius);
  static const Radius medRadius = Radius.circular(med);

  static const double lg = 8;
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);
  static const Radius lgRadius = Radius.circular(lg);
}

class RUtilsTimes {
  RUtilsTimes._();

  static const Duration fastest = Duration(milliseconds: 150);
  static const fast = Duration(milliseconds: 250);
  static const medium = Duration(milliseconds: 350);
  static const slow = Duration(milliseconds: 700);
  static const slower = Duration(milliseconds: 1000);
}

class RUtilsStrokes {
  RUtilsStrokes._();

  static const double thin = 1;
  static const double thick = 4;
}
