import 'dart:ui';

class HexUtils {
  /// Construct a color from a hex code string, of the format #RRGGBB.
  static Color hexToColor(String code) =>
      Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
