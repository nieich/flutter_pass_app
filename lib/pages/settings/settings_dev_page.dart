import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/services/log_service.dart';
import 'package:flutter_pass_app/services/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:share_plus/share_plus.dart';

class SettingsDevPage extends StatefulWidget {
  const SettingsDevPage({super.key});

  @override
  State<SettingsDevPage> createState() => _SettingsDevPageState();
}

class _SettingsDevPageState extends State<SettingsDevPage> {
  final LogService _logService = locator<LogService>();

  @override
  Widget build(BuildContext context) {
    final logs = _logService.logs;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.devLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear Logs',
            onPressed: () {
              setState(() {
                _logService.clear();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: l10n.shareLogs,
            onPressed: () {
              final logString = _logService.getLogsAsString();
              if (logString.isNotEmpty) {
                //Share.share(logString, subject: 'App Logs');
                SharePlus.instance.share(ShareParams(subject: l10n.appLogs, text: logString));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.noLogsToShare)));
              }
            },
          ),
        ],
      ),
      body: logs.isEmpty
          ? Center(child: Text(l10n.noLogsRecordedYet))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    leading: Icon(_getIconForLevel(log.level)),
                    title: Text(log.message),
                    subtitle: Text('${log.level.name} - ${DateFormat.Hms().format(log.time)}'),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIconForLevel(Level level) {
    if (level == Level.SEVERE || level == Level.SHOUT) {
      return Icons.error_outline;
    }
    if (level == Level.WARNING) {
      return Icons.warning_amber_outlined;
    }
    if (level == Level.INFO) {
      return Icons.info_outline;
    }
    return Icons.bug_report_outlined;
  }
}
