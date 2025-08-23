import 'package:flutter/material.dart';
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
