import 'package:flutter/material.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:passkit/passkit.dart';

Widget boardingPassWidget(PkPass pass, BuildContext context) {
  final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDCB61), // Main card color
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
            // Top Section: Logo and Seat
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 30, maxHeight: 30, maxWidth: 96),
                      child: Image.memory(pass.logo!.fromMultiplier(devicePixelRatio.toInt() + 1), fit: BoxFit.contain),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Seat
                    Text(pass.pass.boardingPass!.headerFields?[0].label ?? '', style: TextStyle(fontSize: 14)),
                    Text(
                      pass.pass.boardingPass!.headerFields?[0].value.toString() ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //Group
                    Text(pass.pass.boardingPass!.headerFields?[1].label ?? '', style: TextStyle(fontSize: 14)),
                    Text(
                      pass.pass.boardingPass!.headerFields?[1].value.toString() ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //Gate
                    Text(pass.pass.boardingPass!.headerFields?[2].label ?? '', style: TextStyle(fontSize: 14)),
                    Text(
                      pass.pass.boardingPass!.headerFields?[2].value.toString() ?? '',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Middle Section: Depart and Arrive
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // origin
                    Text(pass.pass.boardingPass!.primaryFields?[0].label ?? '', style: TextStyle(fontSize: 16)),
                    Text(
                      pass.pass.boardingPass!.primaryFields?[0].value.toString() ?? '',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.airplanemode_active, size: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // destination
                    Text(pass.pass.boardingPass!.primaryFields?[1].label ?? '', style: TextStyle(fontSize: 16)),
                    Text(
                      pass.pass.boardingPass!.primaryFields?[1].value.toString() ?? '',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 32),

            // Details Section: Flight, Date, Boarding, Gate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flight
                _buildDetailColumn(
                  pass.pass.boardingPass!.auxiliaryFields?[0].label ?? '',
                  pass.pass.boardingPass!.auxiliaryFields?[0].value.toString() ?? '',
                ),
                // Date
                _buildDetailColumn(
                  pass.pass.boardingPass!.auxiliaryFields?[1].label ?? '',
                  pass.pass.boardingPass!.auxiliaryFields?[1].value.toString() ?? '',
                ),
                // Boarding
                _buildDetailColumn(
                  pass.pass.boardingPass!.auxiliaryFields?[2].label ?? '',
                  pass.pass.boardingPass!.auxiliaryFields?[2].value.toString() ?? '',
                ),
                // Gate closes
                _buildDetailColumn(
                  pass.pass.boardingPass!.auxiliaryFields?[3].label ?? '',
                  pass.pass.boardingPass!.auxiliaryFields?[3].value.toString() ?? '',
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Passenger Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //passenger
                _buildDetailColumn(
                  pass.pass.boardingPass!.secondaryFields?[0].label ?? '',
                  pass.pass.boardingPass!.secondaryFields?[0].value.toString() ?? '',
                ),
                // Class
                _buildDetailColumn(
                  pass.pass.boardingPass!.secondaryFields?[1].label ?? '',
                  pass.pass.boardingPass!.secondaryFields?[1].value.toString() ?? '',
                ),
                // Status
                _buildDetailColumn(
                  pass.pass.boardingPass!.secondaryFields?[2].label ?? '',
                  pass.pass.boardingPass!.secondaryFields?[2].value.toString() ?? '',
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(color: Colors.black, height: 1),
            const SizedBox(height: 32),

            // QR Code Section
            Center(
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return buildBarCodeDialog(pass, context);
                        },
                      );
                    },
                    child: buildBarCodeImage(pass.pass.barcodes!.first),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                pass.pass.barcodes?.first.altText ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
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
  return Card(
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: ListTile(
      leading: getPassCardIcon(pass),
      title: Text(
        pass.pass.boardingPass!.primaryFields?.first.label ?? 'Pass',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(pass.pass.boardingPass!.primaryFields?.first.value.toString() ?? ''),
      trailing: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return buildBarCodeDialog(pass, context);
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
