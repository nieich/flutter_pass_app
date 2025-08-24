import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/base_pass_theme.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:passkit/passkit.dart';

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

Widget basePassCardWidget(
  PassType type,
  FieldDict? field,
  String organizationName,
  String serialNumber,
  Barcode? barcode,
  BasePassTheme passTheme,
  BuildContext context,
) {
  return Card(
    elevation: 10.0,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: passTheme.backgroundColor,
    child: ListTile(
      leading: getPassCardIcon(type, passTheme.foregroundColor),
      title: Text(
        organizationName,
        style: TextStyle(fontWeight: FontWeight.bold, color: passTheme.foregroundColor),
      ),
      subtitle: Text(
        '${field?.label ?? ''} - ${field?.value?.toString() ?? ''}',
        style: TextStyle(color: passTheme.foregroundColor),
      ),
      trailing: barcode != null
          ? GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return buildBarCodeDialog(barcode, context);
                  },
                );
              },
              child: Icon(Icons.qr_code_scanner, color: passTheme.foregroundColor),
            )
          : null,
      onTap: () {
        context.push('${Routes.pathPass}/$serialNumber');
      },
    ),
  );
}
