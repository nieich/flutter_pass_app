import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/boarding_pass_theme.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:flutter_pass_app/widgets/base_pass_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:passkit/passkit.dart';

Widget boardingPassWidget(PkPass pass, BuildContext context) {
  final passTheme = BoardinPassTheme.fromPass(pass);

  return basePassWidget(passTheme, _buildBoardingPassWidget(pass, passTheme, context));
}

Widget _buildBoardingPassWidget(PkPass pass, BoardinPassTheme passTheme, BuildContext context) {
  final barcode = pass.pass.barcodes?.firstOrNull ?? pass.pass.barcode;

  final boardingPass = pass.pass.boardingPass;

  if (boardingPass == null) {
    // Or return a more user-friendly error widget
    return const Center(child: Text('Invalid Boarding Pass Data'));
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Section: Logo and Header Fields
        Padding(padding: const EdgeInsets.all(8.0), child: buildHeader(pass.logo, boardingPass, passTheme, context)),
        const SizedBox(height: 24),

        // Middle Section: Depart and Arrive
        if (boardingPass.primaryFields?.length == 2) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPrimaryField(boardingPass.primaryFields![0], passTheme),
              const Icon(Icons.airplanemode_active, size: 48),
              _buildPrimaryField(boardingPass.primaryFields![1], passTheme, alignment: CrossAxisAlignment.end),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.black, height: 1),
          const SizedBox(height: 32),
        ],

        // Details Section (Auxiliary)
        if (boardingPass.auxiliaryFields?.isNotEmpty ?? false) ...[
          _buildFieldsRow(boardingPass.auxiliaryFields!, passTheme.auxiliaryLabelStyle, passTheme.auxiliaryTextStyle),
          const SizedBox(height: 32),
        ],

        // Passenger Section (Secondary)
        if (boardingPass.secondaryFields?.isNotEmpty ?? false) ...[
          _buildFieldsRow(boardingPass.secondaryFields!, passTheme.secondaryLabelStyle, passTheme.secondaryTextStyle),
          const SizedBox(height: 32),
          const Divider(color: Colors.black, height: 1),
          const SizedBox(height: 32),
        ],

        // QR Code Section
        if (barcode != null) Center(child: buildPassBarcode(barcode, passTheme, context)),
      ],
    ),
  );
}

// Helper for Primary Fields (Origin/Destination)
Widget _buildPrimaryField(
  FieldDict field,
  BoardinPassTheme passTheme, {
  CrossAxisAlignment alignment = CrossAxisAlignment.start,
}) {
  return Column(
    crossAxisAlignment: alignment,
    children: [
      Text(field.label ?? '', style: passTheme.primaryLabelStyle),
      Text(field.value?.toString() ?? '', style: passTheme.primaryTextStyle),
    ],
  );
}

// Helper for Auxiliary and Secondary fields
Widget _buildFieldsRow(List<FieldDict> fields, TextStyle labelStyle, TextStyle valueStyle) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: fields
        .map(
          (field) => Flexible(
            child: _buildDetailColumn(field.label ?? '', field.value?.toString() ?? '', labelStyle, valueStyle),
          ),
        )
        .toList(),
  );
}

// Helper method to build detail columns
Widget _buildDetailColumn(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: labelStyle),
      const SizedBox(height: 4),
      Text(value, style: valueStyle),
    ],
  );
}

Widget buildBoardingPassCard(PkPass pass, BuildContext context) {
  final passTheme = BoardinPassTheme.fromPass(pass);
  final primaryField = pass.pass.boardingPass?.primaryFields?.firstOrNull;
  final barcode = pass.pass.barcodes?.firstOrNull ?? pass.pass.barcode;

  return Card(
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    color: passTheme.backgroundColor,
    child: ListTile(
      leading: getPassCardIcon(pass, passTheme.foregroundColor),
      title: Text(
        pass.pass.organizationName,
        style: TextStyle(fontWeight: FontWeight.bold, color: passTheme.foregroundColor),
      ),
      subtitle: Text(primaryField?.label ?? '', style: TextStyle(color: passTheme.foregroundColor)),
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
        context.push('${Routes.pathPass}/${pass.pass.serialNumber}');
      },
    ),
  );
}
