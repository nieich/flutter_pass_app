import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/utils/helper_functions.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:passkit/passkit.dart';

Widget eventTicketWidget(PkPass pass, BuildContext context) {
  final eventTicket = pass.pass.eventTicket;
  if (eventTicket == null) {
    return const Center(child: Text('Invalid Event Ticket Data'));
  }

  Color background = getColorFromRGBA(pass.pass.backgroundColor?.rgba, Colors.white);
  Color foreground = getColorFromRGBA(pass.pass.foregroundColor?.rgba, Colors.black);
  final headerField = eventTicket.headerFields?.firstOrNull;

  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: Container(
      decoration: BoxDecoration(
        color: background,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // This is the section with the logo and the start time.
          if (pass.logo != null || headerField != null)
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: foreground),
                  ),
                  if (headerField != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(headerField.label ?? '', style: TextStyle(fontSize: 16, color: foreground)),
                        const SizedBox(height: 5),
                        Text(
                          _formatDate(headerField.value?.toString(), AppLocalizations.of(context)!.localeName),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: foreground),
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
            // Center the block of fields, while keeping the text inside left-aligned.
            child: Center(child: _buildAllFields(eventTicket, foreground)),
          ),

          const Divider(color: Colors.black26, indent: 20, endIndent: 20),
          const SizedBox(height: 20),

          //QR Code
          if (pass.pass.barcodes?.isNotEmpty ?? false)
            buildPassBarcode((pass.pass.barcodes!.firstOrNull ?? pass.pass.barcode)!, context),
        ],
      ),
    ),
  );
}

// New helper function to build all field widgets
Widget _buildAllFields(PassStructure eventTicket, Color foreground) {
  final List<Widget> widgets = [];

  // Helper to add a list of fields to the main widget list
  void addFields(List<FieldDict>? fields, {required TextStyle labelStyle, required TextStyle valueStyle}) {
    if (fields?.isNotEmpty ?? false) {
      if (widgets.isNotEmpty) {
        widgets.add(const SizedBox(height: 15));
      }
      for (int i = 0; i < fields!.length; i++) {
        final field = fields[i];
        widgets.add(_buildEventField(field, labelStyle: labelStyle, valueStyle: valueStyle));
        // Add space between fields of the same type, but not after the last one.
        if (i < fields.length - 1) {
          widgets.add(const SizedBox(height: 15));
        }
      }
    }
  }

  addFields(
    eventTicket.primaryFields,
    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: foreground),
    valueStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: foreground),
  );

  addFields(
    eventTicket.secondaryFields,
    labelStyle: TextStyle(fontSize: 16, color: foreground),
    valueStyle: TextStyle(fontSize: 16, color: foreground),
  );

  addFields(
    eventTicket.auxiliaryFields,
    labelStyle: TextStyle(fontSize: 16, color: foreground),
    valueStyle: TextStyle(fontSize: 16, color: foreground),
  );

  return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: widgets);
}

// New helper function to build a single field
Widget _buildEventField(FieldDict field, {required TextStyle labelStyle, required TextStyle valueStyle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (field.label?.isNotEmpty ?? false) ...[Text(field.label!, style: labelStyle), const SizedBox(height: 5)],
      Text(field.value?.toString() ?? '', style: valueStyle),
    ],
  );
}

// Helper for date formatting to avoid crashing on invalid date
String _formatDate(String? dateString, String locale) {
  if (dateString == null) return '';
  try {
    return DateFormat("dd.MM.yyyy HH:mm", locale).format(DateTime.parse(dateString));
  } catch (e) {
    return dateString; // Return original string if parsing fails
  }
}

Widget buildEventTicketCard(PkPass pass, BuildContext context) {
  final primaryField = pass.pass.eventTicket?.primaryFields?.firstOrNull;
  final barcode = pass.pass.barcodes?.firstOrNull ?? pass.pass.barcode;

  return Card(
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: ListTile(
      leading: getPassCardIcon(pass),
      title: Text(pass.pass.organizationName, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(primaryField?.value?.toString() ?? ''),
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
