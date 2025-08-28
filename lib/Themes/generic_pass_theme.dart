import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/base_pass_theme.dart';
import 'package:flutter_pass_app/utils/constants.dart';
import 'package:flutter_pass_app/utils/helper_functions.dart';
import 'package:passkit/passkit.dart';

class GenericPassTheme extends ThemeExtension<GenericPassTheme> implements BasePassTheme {
  GenericPassTheme({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.labelColor,
    required this.logoTextStyle,
    required this.barcodeTextStyle,
    required this.headerLabelStyle,
    required this.headerTextStyle,
    required this.primaryLabelStyle,
    required this.primaryTextStyle,
    required this.secondaryLabelStyle,
    required this.secondaryTextStyle,
    required this.auxiliaryLabelStyle,
    required this.auxiliaryTextStyle,
  });

  factory GenericPassTheme.fromPass(PkPass pass) {
    final backgroundColor = getColorFromRGBA(pass.pass.backgroundColor?.rgba, Constants.defaultBackgroundColor);
    final foregroundColor = getColorFromRGBA(pass.pass.foregroundColor?.rgba, Constants.defaultForegroundColor);
    final labelColor = getColorFromRGBA(pass.pass.labelColor?.rgba, Colors.black);
    final foregroundTextStyle = TextStyle(color: foregroundColor);
    final labelTextStyle = TextStyle(color: labelColor);

    return GenericPassTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      labelColor: labelColor,
      logoTextStyle: foregroundTextStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
      barcodeTextStyle: TextStyle(color: foregroundColor, fontSize: 11),
      headerLabelStyle: labelTextStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w600),
      headerTextStyle: foregroundTextStyle.copyWith(fontSize: 17, height: 0.9),
      primaryLabelStyle: TextStyle(color: foregroundColor, fontSize: 11, fontWeight: FontWeight.w600),
      primaryTextStyle: TextStyle(color: foregroundColor, fontSize: 50, height: 0.9),
      secondaryLabelStyle: TextStyle(color: foregroundColor, fontSize: 11, fontWeight: FontWeight.w600),
      secondaryTextStyle: foregroundTextStyle.copyWith(fontSize: 18, height: 0.9),
      auxiliaryLabelStyle: TextStyle(color: foregroundColor, fontSize: 11, fontWeight: FontWeight.w600),
      auxiliaryTextStyle: TextStyle(color: foregroundColor, fontSize: 18, height: 0.9),
    );
  }

  @override
  Color backgroundColor;
  @override
  Color foregroundColor;
  @override
  Color labelColor;

  @override
  final TextStyle logoTextStyle;
  @override
  final TextStyle barcodeTextStyle;

  @override
  final TextStyle headerLabelStyle;
  @override
  final TextStyle headerTextStyle;

  final TextStyle primaryLabelStyle;
  final TextStyle primaryTextStyle;

  final TextStyle secondaryLabelStyle;
  final TextStyle secondaryTextStyle;

  final TextStyle auxiliaryLabelStyle;
  final TextStyle auxiliaryTextStyle;

  @override
  ThemeExtension<GenericPassTheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<GenericPassTheme> lerp(covariant ThemeExtension<GenericPassTheme>? other, double t) {
    return this;
  }
}
