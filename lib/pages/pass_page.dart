import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/services/pass_service.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:intl/intl.dart';
import 'package:passkit/passkit.dart';
import 'package:passkit_ui/passkit_ui.dart';

class PassPage extends StatelessWidget {
  final String? serialNumber;
  const PassPage({required this.serialNumber, super.key});

  @override
  Widget build(BuildContext context) {
    final pass = PassService.instance.findPass(serialNumber!);

    return Scaffold(
      appBar: AppBar(
        title: Text(pass.pass.description, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(padding: const EdgeInsets.all(8.0), child: _buildTicket(pass, context)),
    );
  }

  Widget _buildTicket(PkPass pass, BuildContext context) {
    Color(pass.pass.backgroundColor!.argbValue);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: pass.pass.backgroundColor?.toDartUiColor() ?? Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // This is the section with the logo and the start time.
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // This uses an asset image. For a real app, you would add the image to your assets folder.
                // For this example, we'll just use a placeholder text.
                Text(
                  pass.pass.organizationName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      pass.pass.eventTicket!.headerFields!.first.label!,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      DateFormat(
                        "dd.MM.yyyy HH:mm",
                        AppLocalizations.of(context)!.localeName,
                      ).format(DateTime.parse(pass.pass.eventTicket!.headerFields!.first.value.toString())),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.black26, indent: 20, endIndent: 20),

          // This section displays the movie and location details.
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pass.pass.eventTicket!.primaryFields!.first.label!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 5),
                Text(
                  pass.pass.eventTicket!.primaryFields!.first.value.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  pass.pass.eventTicket!.secondaryFields!.first.label!,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  pass.pass.eventTicket!.secondaryFields!.first.value.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(
                  pass.pass.eventTicket!.auxiliaryFields!.first.label!,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  pass.pass.eventTicket!.auxiliaryFields!.first.value.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.black26, indent: 20, endIndent: 20),
          const SizedBox(height: 20),

          // This is a placeholder for the QR code image.
          // In a real application, you would use a package like 'qr_flutter' to generate a QR code.
          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BuildBarCodeDialog(pass, context);
                    },
                  );
                },
                child: buildBarCodeImage(pass.pass.barcodes!.first),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            pass.pass.barcodes?.first.altText ?? '',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
