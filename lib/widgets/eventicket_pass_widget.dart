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

    return Image.memory(
      thumbnail!.fromMultiplier(devicePixelRatio.toInt() + 1),
      fit: BoxFit.contain,
      width: 90,
      height: 90,
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

      //AllFields
      Padding(
        padding: const EdgeInsets.all(20.0),
        // Center the block of fields, while keeping the text inside left-aligned.
        child: Row(
          // Changed to Row directly, Center is not needed around Row for this.
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the top
          children: [
            Expanded(
              // The fields will take up available space
              child: _buildAllFields(eventTicket, passTheme),
            ),
            // Add some spacing between the fields and the thumbnail
            const SizedBox(width: 10),
            // The thumbnail will take its intrinsic size, but if too large, it might still overflow if not constrained internally.
            // Assuming Thumbnail internally handles its size or you want it to be a specific size.
            // If the thumbnail is an Image widget, ensure it's not trying to render larger than its parent.
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
