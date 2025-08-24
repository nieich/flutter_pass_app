import 'package:flutter/material.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/utils/helper_functions.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:passkit/passkit.dart';

Widget boardingPassWidget(PkPass pass, BuildContext context) {
  final boardingPass = pass.pass.boardingPass;
  final barcode = pass.pass.barcodes?.firstOrNull ?? pass.pass.barcode;

  if (boardingPass == null) {
    // Or return a more user-friendly error widget
    return const Center(child: Text('Invalid Boarding Pass Data'));
  }

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Container(
      decoration: BoxDecoration(
        color: getColorFromRGBA(pass.pass.backgroundColor?.rgba, Colors.white),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Logo and Header Fields
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pass.logo != null) Logo(logo: pass.logo),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (boardingPass.headerFields?.isNotEmpty ?? false)
                        ...boardingPass.headerFields!.map(
                          (field) => Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(field.label ?? '', style: const TextStyle(fontSize: 14)),
                                  Text(
                                    field.value?.toString() ?? '',
                                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Middle Section: Depart and Arrive
            if (boardingPass.primaryFields?.length == 2) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPrimaryField(boardingPass.primaryFields![0]),
                  const Icon(Icons.airplanemode_active, size: 48),
                  _buildPrimaryField(boardingPass.primaryFields![1], alignment: CrossAxisAlignment.end),
                ],
              ),
              const SizedBox(height: 32),
              const Divider(color: Colors.black, height: 1),
              const SizedBox(height: 32),
            ],

            // Details Section (Auxiliary)
            if (boardingPass.auxiliaryFields?.isNotEmpty ?? false) ...[
              _buildFieldsRow(boardingPass.auxiliaryFields!),
              const SizedBox(height: 32),
            ],

            // Passenger Section (Secondary)
            if (boardingPass.secondaryFields?.isNotEmpty ?? false) ...[
              _buildFieldsRow(boardingPass.secondaryFields!),
              const SizedBox(height: 32),
              const Divider(color: Colors.black, height: 1),
              const SizedBox(height: 32),
            ],

            // QR Code Section
            if (barcode != null) Center(child: buildPassBarcode(barcode, context)),
          ],
        ),
      ),
    ),
  );
}

// Helper for Primary Fields (Origin/Destination)
Widget _buildPrimaryField(FieldDict field, {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
  return Column(
    crossAxisAlignment: alignment,
    children: [
      Text(field.label ?? '', style: const TextStyle(fontSize: 16)),
      Text(field.value?.toString() ?? '', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
    ],
  );
}

// Helper for Auxiliary and Secondary fields
Widget _buildFieldsRow(List<FieldDict> fields) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: fields
        .map((field) => Flexible(child: _buildDetailColumn(field.label ?? '', field.value?.toString() ?? '')))
        .toList(),
  );
}

// Helper method to build detail columns
Widget _buildDetailColumn(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ],
  );
}

Widget buildBoardingPassCard(PkPass pass, BuildContext context) {
  final primaryField = pass.pass.boardingPass?.primaryFields?.firstOrNull;
  final barcode = pass.pass.barcodes?.firstOrNull ?? pass.pass.barcode;

  return Card(
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: ListTile(
      leading: getPassCardIcon(pass),
      title: Text(pass.pass.organizationName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(primaryField?.label ?? ''),
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
              child: const Icon(Icons.qr_code_scanner),
            )
          : null,
      onTap: () {
        context.push('${Routes.pathPass}/${pass.pass.serialNumber}');
      },
    ),
  );
}
