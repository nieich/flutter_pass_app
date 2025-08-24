import 'package:flutter/material.dart';
import 'package:flutter_pass_app/Themes/base_pass_theme.dart';
import 'package:flutter_pass_app/utils/barcode_functions.dart';
import 'package:flutter_pass_app/widgets/boarding_pass_widget.dart';
import 'package:flutter_pass_app/widgets/coupon_pass_widget.dart';
import 'package:flutter_pass_app/widgets/eventicket_pass_widget.dart';
import 'package:flutter_pass_app/widgets/generic_pass_widget.dart';
import 'package:flutter_pass_app/widgets/storecard_pass_widget.dart';
import 'package:passkit/passkit.dart';

Widget getPassWidget(PkPass pass, BuildContext context) {
  switch (pass.type) {
    case PassType.boardingPass:
      return boardingPassWidget(pass, context);
    //return BoardingPassWidget(pass: pass);
    case PassType.coupon:
      return couponWidget(pass, context);
    //return CouponWidget(pass: pass);
    case PassType.eventTicket:
      return eventTicketWidget(pass, context);
    case PassType.storeCard:
      return storeCardWidget(pass, context);
    //return StoreCardWidget(pass: pass);
    case PassType.generic:
      return genericPassWidget(pass, context);
    //return GenericWidget(pass: pass);
  }
}

Icon getPassCardIcon(PkPass pass) {
  switch (pass.type) {
    case PassType.boardingPass:
      return const Icon(Icons.airplane_ticket, color: Colors.blue, size: 40);
    case PassType.coupon:
      return const Icon(Icons.card_giftcard, color: Colors.green, size: 40);
    case PassType.eventTicket:
      return const Icon(Icons.event, color: Colors.orange, size: 40);
    case PassType.storeCard:
      return const Icon(Icons.store, color: Colors.red, size: 40);
    case PassType.generic:
      return const Icon(Icons.credit_card, color: Colors.purple, size: 40);
  }
}

Widget buildPassCard(PkPass pass, BuildContext context) {
  switch (pass.type) {
    case PassType.boardingPass:
      return buildBoardingPassCard(pass, context);
    case PassType.coupon:
      return buildCouponCard(pass, context);
    case PassType.eventTicket:
      return buildEventTicketCard(pass, context);
    case PassType.storeCard:
      return buildStoreCardCard(pass, context);
    case PassType.generic:
      return buildGenericPassCard(pass, context);
  }
}

Widget buildHeader(PkImage? logo, PassStructure pass, BasePassTheme passTheme, BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (logo != null) Logo(logo: logo),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (pass.headerFields?.isNotEmpty ?? false)
              ...pass.headerFields!.map(
                (field) => Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(field.label ?? '', style: passTheme.headerLabelStyle),
                        Text(field.value?.toString() ?? '', style: passTheme.headerTextStyle),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

Widget buildPassBarcode(Barcode barcode, BasePassTheme passTheme, BuildContext context) {
  return Column(
    children: [
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
                  return buildBarCodeDialog(barcode, context);
                },
              );
            },
            child: buildBarCodeImage(barcode),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Center(child: Text(barcode.altText ?? '', style: passTheme.barcodeTextStyle)),
      const SizedBox(height: 40),
    ],
  );
}

class Logo extends StatelessWidget {
  const Logo({super.key, this.logo});

  final PkImage? logo;

  @override
  Widget build(BuildContext context) {
    if (logo == null) return const SizedBox.shrink();

    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 30, maxHeight: 30, maxWidth: 96),
      child: Image.memory(logo!.fromMultiplier(devicePixelRatio.toInt() + 1), fit: BoxFit.contain),
    );
  }
}
