import 'package:flutter/material.dart';
import 'package:csslib/parser.dart' as css_color;

Color getColorFromRGBA(css_color.Rgba? rgba, Color defaultColor) {
  if (rgba == null) {
    return defaultColor;
  }
  return Color.fromARGB(255, rgba.r, rgba.g, rgba.b);
}
