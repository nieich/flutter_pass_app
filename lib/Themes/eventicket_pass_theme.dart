import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/base_pass_theme.dart';
import 'package:flutter_pass_app/utils/helper_functions.dart';
import 'package:passkit/passkit.dart';

class EventTicketTheme extends ThemeExtension<EventTicketTheme> implements BasePassTheme {
  EventTicketTheme({
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

  factory EventTicketTheme.fromPass(PkPass pass) {
    final backgroundColor = getColorFromRGBA(pass.pass.backgroundColor?.rgba, Colors.white);
    final foregroundColor = getColorFromRGBA(pass.pass.foregroundColor?.rgba, Colors.black);
    final labelColor = getColorFromRGBA(pass.pass.labelColor?.rgba, Colors.black);
    final foregroundTextStyle = TextStyle(color: foregroundColor);
    final labelTextStyle = TextStyle(color: labelColor);

    return EventTicketTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      labelColor: labelColor,
      barcodeTextStyle: TextStyle(color: foregroundColor, fontSize: 11),
      logoTextStyle: foregroundTextStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
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

  final TextStyle headerLabelStyle;
  final TextStyle headerTextStyle;

  final TextStyle primaryLabelStyle;
  final TextStyle primaryTextStyle;

  final TextStyle secondaryLabelStyle;
  final TextStyle secondaryTextStyle;

  final TextStyle auxiliaryLabelStyle;
  final TextStyle auxiliaryTextStyle;

  @override
  ThemeExtension<EventTicketTheme> copyWith() {
    return this;
  }

  @override
  ThemeExtension<EventTicketTheme> lerp(covariant ThemeExtension<EventTicketTheme>? other, double t) {
    return this;
  }
}
