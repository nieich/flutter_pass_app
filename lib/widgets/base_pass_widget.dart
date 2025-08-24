import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/base_pass_theme.dart';

Widget basePassWidget(BasePassTheme passTheme, Widget passWidget) {
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Container(
      decoration: BoxDecoration(
        color: passTheme.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: passWidget,
    ),
  );
}
