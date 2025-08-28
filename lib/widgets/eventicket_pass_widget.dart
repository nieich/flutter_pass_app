import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/eventicket_pass_theme.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:flutter_pass_app/widgets/base_pass_widget.dart';
import 'package:passkit/passkit.dart';

class Thumbnail extends StatelessWidget {
  const Thumbnail({super.key, this.thumbnail});

  final PkImage? thumbnail;

  @override
  Widget build(BuildContext context) {
    if (thumbnail == null) return const SizedBox.shrink();

    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final imageData = thumbnail!.fromMultiplier(devicePixelRatio.toInt() + 1);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            pageBuilder: (BuildContext context, _, __) {
              return _EnlargedThumbnailView(imageData: imageData);
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Image.memory(imageData, fit: BoxFit.contain, width: 90, height: 90),
    );
  }
}

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

      // Primary Fields
      Padding(padding: const EdgeInsets.all(20.0), child: _buildPrimaryFields(eventTicket, passTheme)),

      // Secondary/Auxiliary Fields and Thumbnail
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end, // Align content to the bottom
          children: [
            Expanded(
              // The fields will take up available space
              child: _buildSecondaryAndAuxiliaryFields(eventTicket, passTheme),
            ),
            // Add some spacing between the fields and the thumbnail
            const SizedBox(width: 10),
            Thumbnail(thumbnail: pass.thumbnail),
          ],
        ),
      ),

      Divider(color: passTheme.foregroundColor.withValues(alpha: 0.4), indent: 20, endIndent: 20),
      const SizedBox(height: 20),

      //QR Code
      if (pass.pass.barcodes?.isNotEmpty ?? false)
        buildPassBarcode((pass.pass.barcodes!.firstOrNull ?? pass.pass.barcode)!, passTheme, context),
    ],
  );
}

class _EnlargedThumbnailView extends StatelessWidget {
  const _EnlargedThumbnailView({required this.imageData});

  final Uint8List imageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.85),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: InteractiveViewer(panEnabled: false, minScale: 1.0, maxScale: 4.0, child: Image.memory(imageData)),
        ),
      ),
    );
  }
}

// New helper function to build primary fields, often laid out in a row
Widget _buildPrimaryFields(PassStructure eventTicket, EventTicketTheme theme) {
  final primaryFields = eventTicket.primaryFields;
  if (primaryFields == null || primaryFields.isEmpty) {
    return const SizedBox.shrink();
  }

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: primaryFields
        .map(
          (field) => Expanded(
            child: _buildEventField(field, labelStyle: theme.primaryLabelStyle, valueStyle: theme.primaryTextStyle),
          ),
        )
        .toList(),
  );
}

// Renamed and modified to handle secondary and auxiliary fields
Widget _buildSecondaryAndAuxiliaryFields(PassStructure eventTicket, EventTicketTheme theme) {
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
