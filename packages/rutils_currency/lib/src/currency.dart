import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:intl/number_symbols_data.dart';

class Currency {
  Currency._();

  /// Returns the currency symbol for the given locale.
  static String getCurrencySymbol(Locale locale) {
    final NumberSymbols currencySymbolName =
        numberFormatSymbols[locale.languageCode];
    final numberFormatCurrency = NumberFormat.compact(
      locale: _getLanguageTag(locale),
    );

    return numberFormatCurrency.simpleCurrencySymbol(
      currencySymbolName.DEF_CURRENCY_CODE,
    );
  }

  /// Return formatted value of the given amount and the given currency.
  static String getFormattedValue(
    String? symbol,
    num? value,
    Locale locale,
  ) {
    final numberFormat = NumberFormat.currency(
      locale: _getLanguageTag(locale),
      symbol: symbol,
    );

    return numberFormat.format(value ?? 0);
  }

  static String _getLanguageTag(Locale locale) {
    final currentLocale = locale.toLanguageTag();

    return currentLocale.replaceAll('-', '_');
  }

  static double formattedCurrencyToDouble(String? amount) {
    if (amount == null || amount.isEmpty) {
      return 0;
    }

    return double.tryParse(
          amount.replaceAll(' ', '').replaceAll('.', '').replaceAll(',', '.'),
        ) ??
        0;
  }
}
