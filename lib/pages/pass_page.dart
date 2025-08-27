import 'package:flutter/material.dart';
import 'package:flutter_pass_app/services/service_locator.dart';
import 'package:flutter_pass_app/services/services.dart';
import 'package:flutter_pass_app/utils/pass_functions.dart';
import 'package:passkit/passkit.dart';
import 'package:share_plus/share_plus.dart';

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
    _pass = locator<PassService>().findPass(widget.serialNumber!);
  }

  Future<void> _handleRefresh() async {
    // A pass can only be refreshed if it has a webservice URL.
    if (_pass.pass.webServiceURL == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('This pass does not support updates.')));
      return;
    }

    final updatedPass = await locator<PassService>().updatePass(widget.serialNumber!);

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

  Future<void> _handleDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Pass'),
          content: const Text('Are you sure you want to delete this pass? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop(false)),
            TextButton(child: const Text('Delete'), onPressed: () => Navigator.of(context).pop(true)),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final nav = Navigator.of(context);
      await locator<PassService>().deletePass(widget.serialNumber!);
      nav.pop();
    }
  }

  Future<void> _handleShare() async {
    final filePath = await locator<PassFileStorageService>().getPassFilePath(_pass.pass.serialNumber);

    SharePlus.instance.share(ShareParams(files: [XFile(filePath)], subject: 'Sharing Pass: ${_pass.pass.description}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pass.pass.description),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') _handleDelete();
              if (value == 'share') _handleShare();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.share, color: Colors.blue), // Your icon here
                    SizedBox(width: 8), // Spacing between icon and text
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete_forever, color: Colors.red), // Your icon here
                    SizedBox(width: 8), // Spacing between icon and text
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
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
