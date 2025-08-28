import 'package:flutter/material.dart';
import 'package:passkit/passkit.dart';
import 'package:barcode_widget/barcode_widget.dart' as bw;

bw.BarcodeWidget buildBarCodeImage(Barcode barcode, {double size = 200}) {
  switch (barcode.format) {
    case PkPassBarcodeType.qr:
      return bw.BarcodeWidget(barcode: bw.Barcode.qrCode(), data: barcode.message, width: size, height: size);
    case PkPassBarcodeType.code128:
      return bw.BarcodeWidget(barcode: bw.Barcode.code128(), data: barcode.message, width: size, height: size);
    case PkPassBarcodeType.pdf417:
      return bw.BarcodeWidget(barcode: bw.Barcode.pdf417(), data: barcode.message, width: size, height: size);
    case PkPassBarcodeType.aztec:
      bw.BarcodeWidget(barcode: bw.Barcode.aztec(), data: barcode.message, width: size, height: size);
  }

  return bw.BarcodeWidget(barcode: bw.Barcode.qrCode(), data: barcode.message, width: size, height: size);
}

Dialog buildBarCodeDialog(Barcode barcode, BuildContext context) {
  // Use MediaQuery to make the dialog size relative to the screen size.
  final screenWidth = MediaQuery.of(context).size.width;
  // Define paddings and margins
  const dialogMargin = 20.0;
  const contentPadding = 20.0;
  // Calculate the size for the barcode to fit within the dialog
  final qrSize = screenWidth - (dialogMargin * 2) - (contentPadding * 2);

  return Dialog(
    // This reduces the margin around the dialog, making it larger.
    insetPadding: const EdgeInsets.all(dialogMargin),
    backgroundColor: Colors.white, //neds to be white for barcode visibility
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.all(contentPadding),
      child: buildBarCodeImage(barcode, size: qrSize),
    ),
  );
}
