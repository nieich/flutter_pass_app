import 'package:flutter/material.dart';
import 'package:flutter_pass_app/services/pass_service.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:passkit/passkit.dart';

class PassPage extends StatefulWidget {
  final String? serialNumber;
  const PassPage({required this.serialNumber, super.key});

  @override
  State<PassPage> createState() => _PassPageState();
}

class _PassPageState extends State<PassPage> {
  late PkPass _pass;

  @override
  void initState() {
    super.initState();
    // It's better to fetch the pass here rather than in the build method.
    // The bang operator (!) is used here, assuming serialNumber is never null
    // when this page is navigated to, as in the original code.
    _pass = PassService.instance.findPass(widget.serialNumber!);
  }

  Future<void> _handleRefresh() async {
    // A pass can only be refreshed if it has a webservice URL.
    if (_pass.pass.webServiceURL == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This pass does not support updates.')));
      return;
    }

    final updatedPass = await PassService.instance.updatePass(widget.serialNumber!);

    if (updatedPass != null && mounted) {
      setState(() {
        _pass = updatedPass;
      });
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to update pass or no update available.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pass.pass.description),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(padding: const EdgeInsets.all(8.0), child: getPassWidget(_pass, context)),
        ),
      ),
    );
  }
}
