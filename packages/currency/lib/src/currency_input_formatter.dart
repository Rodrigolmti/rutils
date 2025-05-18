import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/**
 * Given a [locale] string, example pt_BR, returns the
 * formatted value in the locale. Like 1000,00 -> R$ 1.000,00.
 * If [locale] is not specified, it will use the current default locale.
 */
class CurrencyInputFormatter extends TextInputFormatter {
  final String? locale;
  CurrencyInputFormatter({this.locale});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      print(true);
      return newValue;
    }

    final value = int.parse(newValue.text.replaceAll('.', ''));

    final formatter = NumberFormat.simpleCurrency(locale: locale);

    final newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
