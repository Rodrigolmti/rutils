import 'package:easy_mask/easy_mask.dart';

class Formatters {
  static String maskCpf(String document) {
    if (document.isEmpty || document.length != 11) {
      return document;
    }

    final first3digits = document.substring(3, 6);
    final second3Digits = document.substring(6, 9);

    return '***$first3digits.$second3Digits**';
  }

  static String formatCpf(String document) {
    final mask = MagicMask.buildMask('999.999.999-99');
    return mask.getMaskedString(document);
  }
}
