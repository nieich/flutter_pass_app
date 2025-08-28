import 'package:flutter/material.dart';
import 'package:passkit/passkit.dart';
import 'package:passkit_ui/passkit_ui.dart';

Widget couponWidget(PkPass pass, BuildContext context) {
  return PkPassWidget(pass: pass);
}