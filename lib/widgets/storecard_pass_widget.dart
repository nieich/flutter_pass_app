import 'package:flutter/material.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:passkit/passkit.dart';
import 'package:passkit_ui/passkit_ui.dart';

Widget storeCardWidget(PkPass pass, BuildContext context) {
  return PkPassWidget(pass: pass);
}

Widget buildStoreCardCard(PkPass pass, BuildContext context) {
  return Card(
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: ListTile(
      leading: getPassCardIcon(pass),
      title: Text(
        pass.pass.storeCard!.primaryFields?.first.label ?? 'Pass',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(pass.pass.storeCard!.primaryFields?.first.value.toString() ?? ''),
      trailing: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return buildBarCodeDialog((pass.pass.barcodes?.firstOrNull ?? pass.pass.barcode)!, context);
            },
          );
        },
        child: const Icon(Icons.qr_code_scanner),
      ),
      onTap: () {
        context.push('${Routes.pathPass}/${pass.pass.serialNumber}');
      },
    ),
  );
}
