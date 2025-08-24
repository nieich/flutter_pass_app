import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/eventicket_pass_theme.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:flutter_pass_app/widgets/base_pass_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:passkit/passkit.dart';

Widget eventTicketWidget(PkPass pass, BuildContext context) {
  final eventTicket = pass.pass.eventTicket;

  if (eventTicket == null) {
    return const Center(child: Text('Invalid Event Ticket Data'));
  }

  final passTheme = EventTicketTheme.fromPass(pass);

  return basePassWidget(passTheme, _buildEventTicketPass(passTheme, pass, eventTicket, context));
}

Widget _buildEventTicketPass(EventTicketTheme passTheme, PkPass pass, PassStructure eventTicket, BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      // Header
      Padding(padding: const EdgeInsets.all(8.0), child: buildHeader(pass.logo, eventTicket, passTheme, context)),
      //Divider
      Divider(color: passTheme.foregroundColor.withValues(alpha: 0.4), indent: 20, endIndent: 20),

      //AllFields
      Padding(
        padding: const EdgeInsets.all(20.0),
        // Center the block of fields, while keeping the text inside left-aligned.
        child: Center(child: _buildAllFields(eventTicket, passTheme)),
      ),

      Divider(color: passTheme.foregroundColor.withValues(alpha: 0.4), indent: 20, endIndent: 20),
      const SizedBox(height: 20),

      //QR Code
      if (pass.pass.barcodes?.isNotEmpty ?? false)
        buildPassBarcode((pass.pass.barcodes!.firstOrNull ?? pass.pass.barcode)!, passTheme, context),
    ],
  );
}

// New helper function to build all field widgets
Widget _buildAllFields(PassStructure eventTicket, EventTicketTheme theme) {
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

  //primaryFields
  addFields(eventTicket.primaryFields, labelStyle: theme.primaryLabelStyle, valueStyle: theme.primaryTextStyle);
  //secondaryFields
  addFields(eventTicket.secondaryFields, labelStyle: theme.secondaryLabelStyle, valueStyle: theme.secondaryTextStyle);
  //auxiliaryFields
  addFields(eventTicket.auxiliaryFields, labelStyle: theme.auxiliaryLabelStyle, valueStyle: theme.auxiliaryTextStyle);

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
