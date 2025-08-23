import 'package:flutter/material.dart';
import 'package:passkit/passkit.dart';
import 'package:passkit_ui/passkit_ui.dart';

Widget boardingPassWidget(PkPass pass, BuildContext context) {
  return PkPassWidget(pass: pass);
}
