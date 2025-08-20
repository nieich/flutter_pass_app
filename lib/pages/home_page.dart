import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _pickedFileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.title,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
              context.push(Routes.pathSettings);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        tooltip: AppLocalizations.of(context)!.addPassFromFile,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // Using ListView.builder is more efficient for long lists.
    return ListView.builder(
      itemCount: 5, // Example count
      itemBuilder: (context, index) => _buildPassCard(context),
    );
  }

  Future<void> _pickFile() async {
    final l10n = AppLocalizations.of(context)!;
    // Using FileType.any is more robust for custom file types like .pkpass,
    // as platform-native pickers may not support filtering by this extension.
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null) {
      final file = result.files.single;
      // Manually check the file extension.
      if (file.extension?.toLowerCase() != 'pkpass') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.invalidFileType)));
        }
        return;
      }

      setState(() {
        _pickedFileName = file.name;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pickedFile(_pickedFileName!))));
      }
    }
  }

  Widget _buildPassCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.airplane_ticket, color: Theme.of(context).colorScheme.primary, size: 40),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Boarding Pass', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Flight to New York'),
                    ],
                  ),
                ),
                Icon(Icons.qr_code_scanner),
              ],
            ),
            const Divider(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PASSENGER', style: TextStyle(color: Colors.grey)),
                    Text('John Doe', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('GATE', style: TextStyle(color: Colors.grey)),
                    Text('B42', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
