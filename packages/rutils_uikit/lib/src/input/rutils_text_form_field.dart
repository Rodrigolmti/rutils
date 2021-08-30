import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rutils_uikit/rutils_uikit.dart';
import 'package:rutils_uikit/src/input/rutils_text_form_style.dart';

enum Suffix { noSuffix, clearBtn, alertBtn, obscureText }

/// A custom textformFild widget
/// [suffixBtn] can be [Suffix.clearBtn], [Suffix.alertBtn]
/// or [Suffix.obscureText]
/// Most of the properties are same as [TextFormField]
/// Credits: @Pedroculque for the suffix logic
class RUtilsTextFormField extends StatefulWidget {
  final RUtilsTextFormStyle? textFormStyle;

  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? tooltip;
  final String? errorLabel;
  final TextCapitalization textCapitalization;

  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;

  final int? maxLines;
  final String? initialValue;

  final bool enabled;
  final bool autofocus;
  final OnSubmitCallback? onSubmitCallback;
  final OnChangeCallback? onChangeCallback;
  final List<TextInputFormatter>? inputFormatters;
  final ToolbarOptions? toolbarOptions;
  final Color? suffixColor;
  final Suffix suffixBtn;
  final int? maxLength;
  final List<String>? autofillHints;

  const RUtilsTextFormField({
    Key? key,
    this.textFormStyle,
    this.labelText,
    this.errorLabel,
    this.hintText,
    this.helperText,
    this.maxLines,
    this.tooltip,
    this.validator,
    this.controller,
    this.initialValue,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.suffixBtn = Suffix.noSuffix,
    this.suffixColor = Colors.black,
    this.enabled = true,
    this.onChangeCallback,
    this.onSubmitCallback,
    this.inputFormatters,
    this.toolbarOptions,
    this.maxLength,

    /// Adds hints so OS can suggest autofill options.
    /// Very useful for one time passwords.
    /// See [AutofillHints] for allowed values.
    this.autofillHints,
  }) : super(key: key);

  @override
  _RUtilsTextFormFieldState createState() => _RUtilsTextFormFieldState();
}

class _RUtilsTextFormFieldState extends State<RUtilsTextFormField> {
  // Initially password is obscure
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.suffixBtn == Suffix.obscureText;
  }

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: widget.textFormStyle?.textFormStyle,
        decoration: _buildInputDecoration(),
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofocus: widget.autofocus,
        enabled: widget.enabled,
        maxLines: widget.maxLines,
        initialValue: widget.initialValue,
        toolbarOptions: widget.toolbarOptions,
        validator: widget.validator,
        onChanged: widget.onChangeCallback,
        maxLength: widget.maxLength,
        onFieldSubmitted: (value) {
          if (widget.onSubmitCallback != null) {
            widget.onSubmitCallback!(value);
          }
        },
        inputFormatters: widget.inputFormatters,
        cursorColor: widget.textFormStyle?.cursorColor,
        obscureText: _obscureText,
        autofillHints: widget.autofillHints,
      );

  InputDecoration _buildInputDecoration() => InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.textFormStyle?.labelStyle,
        hintText: widget.hintText,
        hintStyle: widget.textFormStyle?.hintStyle,
        suffixIcon: _buildSuffixIcon(),
        helperText: widget.helperText ?? '',
        errorText: widget.errorLabel,
        helperStyle: widget.textFormStyle?.errorStyle,
        errorStyle: widget.textFormStyle?.errorStyle,
        errorBorder: widget.textFormStyle?.errorBorder,
        focusedBorder: widget.textFormStyle?.focusedBorder,
        focusedErrorBorder: widget.textFormStyle?.focusedErrorBorder,
        disabledBorder: widget.textFormStyle?.disabledBorder,
        border: widget.textFormStyle?.border,
        enabledBorder: widget.textFormStyle?.enabledBorder,
      );

  Widget? _buildSuffixIcon() {
    switch (widget.suffixBtn) {
      case Suffix.noSuffix:
        return null;
      case Suffix.clearBtn:
        return CoreAssets(
          pathAssets: 'packages/rutils_uikit/assets/icons/close.svg',
          onPressed: () => {
            if (widget.controller != null) widget.controller!.clear(),
          },
          color: widget.suffixColor,
          tooltip: widget.tooltip,
        );
      case Suffix.alertBtn:
        return CoreAssets(
          pathAssets: 'packages/rutils_uikit/assets/icons/error.svg',
          onPressed: () => {},
          tooltip: widget.tooltip,
          color: widget.suffixColor,
        );
      case Suffix.obscureText:
        if (_obscureText) {
          return CoreAssets(
            pathAssets: 'packages/rutils_uikit/assets/icons/open_eye.svg',
            color: widget.suffixColor,
            onPressed: () => {
              setState(() {
                _obscureText = !_obscureText;
              })
            },
            tooltip: widget.tooltip,
          );
        } else {
          return CoreAssets(
            pathAssets: 'packages/rutils_uikit/assets/icons/close_eye.svg',
            color: widget.suffixColor,
            onPressed: () => {
              setState(() {
                _obscureText = !_obscureText;
              })
            },
            tooltip: widget.tooltip,
          );
        }
    }
  }
}

typedef OnSubmitCallback = Function(String text);
typedef OnChangeCallback = Function(String text);
