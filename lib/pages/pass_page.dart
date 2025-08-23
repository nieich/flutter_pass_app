import 'package:flutter/material.dart';
import 'package:flutter_pass_app/services/pass_service.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';

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
      body: Padding(padding: const EdgeInsets.all(8.0), child: getPassWidget(pass, context)),
    );
  }


}
