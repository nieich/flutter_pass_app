import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
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
  late AppLocalizations l10n;

  @override
  void initState() {
    super.initState();
    // It's better to fetch the pass here rather than in the build method.
    // The bang operator (!) is used here, assuming serialNumber is never null
    // when this page is navigated to, as in the original code.
    _pass = locator<PassService>().findPass(widget.serialNumber!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // It's best practice to get context-dependent objects in didChangeDependencies.
    l10n = AppLocalizations.of(context)!;
  }

  Future<void> _handleRefresh() async {
    // A pass can only be refreshed if it has a webservice URL.
    if (_pass.pass.webServiceURL == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.passDoesNotSupportUpdates)));
      }
      return;
    }

    final updatedPass = await locator<PassService>().updatePass(widget.serialNumber!);

    if (!mounted) return;

    if (updatedPass != null) {
      setState(() {
        _pass = updatedPass;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.passUpdateFailedOrNoUpdateAvailable)));
    }
  }

  Future<void> _handleDelete() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.deletePass),
          content: Text(l10n.deletePassConfirmation),
          actions: <Widget>[
            TextButton(child: Text(l10n.cancel), onPressed: () => Navigator.of(context).pop(false)),
            TextButton(child: Text(l10n.delete), onPressed: () => Navigator.of(context).pop(true)),
          ],
        );
      },
    );

    // The widget might have been unmounted while the dialog was open.
    if (confirmed != true || !mounted) return;

    await locator<PassService>().deletePass(widget.serialNumber!);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleShare() async {
    final filePath = await locator<PassFileStorageService>().getPassFilePath(_pass.pass.serialNumber);

    SharePlus.instance.share(
      ShareParams(files: [XFile(filePath)], subject: '${l10n.sharingPass} ${_pass.pass.description}'),
    );
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
              switch (value) {
                case 'delete':
                  _handleDelete();
                  break;
                case 'share':
                  _handleShare();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'share',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.share, color: Colors.blue), // Your icon here
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(l10n.share),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete_forever, color: Colors.red), // Your icon here
                    SizedBox(width: 8), // Spacing between icon and text
                    Text(l10n.delete),
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
