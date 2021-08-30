import 'package:flutter/material.dart';

/// With this class you can configure the [TextField] styles
/// If you do not pass any of them the component will get the default
/// of the Material or Cupertino app
class RUtilsTextFormStyle {
  final TextStyle? textFormStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? disabledBorder;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final Color? cursorColor;
  const RUtilsTextFormStyle({
    this.textFormStyle,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.disabledBorder,
    this.border,
    this.enabledBorder,
    this.cursorColor,
  });
}
