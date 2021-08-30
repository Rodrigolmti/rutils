import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rutils_uikit/src/input/rutils_text_form_field.dart';
import 'package:rutils_uikit/src/input/rutils_text_form_style.dart';

/// Currency input field, with a formatter that formats the value as a currency.
/// You need to pass a Locale to the constructor, so that the formatter can
/// use the correct currency symbol.
///
/// Also you need to provide a prefixText, you can user the function
/// getCurrencySymbol on the package tool_kit to get the currency
/// symbol with the locale.
class RUtilsCurrencyTextFormField extends StatefulWidget {
  final RUtilsTextFormStyle? textFormStyle;

  final TextEditingController? controller;
  final Locale locale;
  final String? hintText;
  final String? labelText;
  final String? prefixText;
  final String? errorLabel;
  final String? initialValue;

  final FormFieldValidator<String>? validator;
  final TextInputAction textInputAction;

  final bool enabled;
  final bool autofocus;
  final OnSubmitCallback? onSubmitCallback;
  final OnChangeCallback? onChangeCallback;
  final List<TextInputFormatter>? inputFormatters;
  final ToolbarOptions? toolbarOptions;
  final List<String> autofillHints;

  const RUtilsCurrencyTextFormField({
    required this.locale,
    Key? key,
    this.errorLabel,
    this.hintText,
    this.validator,
    this.initialValue,
    this.prefixText,
    this.textFormStyle,
    this.labelText,
    this.controller,
    this.autofocus = false,
    this.textInputAction = TextInputAction.done,
    this.enabled = true,
    this.onChangeCallback,
    this.onSubmitCallback,
    this.inputFormatters,
    this.toolbarOptions,
    this.autofillHints = const [AutofillHints.transactionAmount],
  }) : super(key: key);

  @override
  _RUtilsCurrencyTextFormFieldState createState() =>
      _RUtilsCurrencyTextFormFieldState();
}

class _RUtilsCurrencyTextFormFieldState
    extends State<RUtilsCurrencyTextFormField> {
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        style: widget.textFormStyle?.textFormStyle,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        textAlignVertical: TextAlignVertical.center,
        initialValue: widget.initialValue,
        toolbarOptions: widget.toolbarOptions,
        textAlign: TextAlign.end,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
          _CurrencyInputFormatter(
            locale: widget.locale,
          )
        ],
        keyboardType: TextInputType.number,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChangeCallback,
        onFieldSubmitted: (value) {
          if (widget.onSubmitCallback != null) {
            widget.onSubmitCallback!(value);
          }
        },
        autofillHints: widget.autofillHints,
        decoration: InputDecoration(
          isDense: true,
          labelText: widget.labelText,
          labelStyle: widget.textFormStyle?.labelStyle,
          prefixText: widget.prefixText,
          prefixStyle: widget.textFormStyle?.prefixStyle,
          hintText: widget.hintText,
          hintStyle: widget.textFormStyle?.hintStyle,
          errorText: widget.errorLabel,
          errorStyle: widget.textFormStyle?.errorStyle,
          errorBorder: widget.textFormStyle?.errorBorder,
          focusedBorder: widget.textFormStyle?.focusedBorder,
          focusedErrorBorder: widget.textFormStyle?.focusedErrorBorder,
          border: widget.textFormStyle?.border,
          enabledBorder: widget.textFormStyle?.enabledBorder,
        ),
      );
}

class _CurrencyInputFormatter extends TextInputFormatter {
  final Locale locale;

  _CurrencyInputFormatter({
    required this.locale,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final value = int.parse(newValue.text.replaceAll('.', ''));

    final formatter = NumberFormat.simpleCurrency(
      locale: '${locale.languageCode}_${locale.countryCode}',
      name: '',
    );

    final newText = formatter.format(value / 100);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
