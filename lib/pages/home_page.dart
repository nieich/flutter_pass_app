import 'package:flutter/material.dart';
import 'package:flutter_pass_app/l10n/app_localizations.dart';
import 'package:flutter_pass_app/navigation/routes.dart';
import 'package:flutter_pass_app/services/pass_service.dart';
import 'package:go_router/go_router.dart';
import 'package:passkit/passkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Use the singleton instances of your services
  final _passService = PassService.instance;

  // Local state to hold the list of passes
  List<PkPass> _passes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load passes from storage when the widget is first created
    _passes = _passService.passes;
    _isLoading = false;
  }

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
        onPressed: () => _pickAndAddPass(context),
        tooltip: AppLocalizations.of(context)!.addPassFromFile,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_passes.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noPasses, style: Theme.of(context).textTheme.titleMedium),
      );
    }

    return ListView.builder(
      itemCount: _passes.length,
      itemBuilder: (context, index) => _buildPassCard(context, _passes[index]),
    );
  }

  Future<void> _pickAndAddPass(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);

    try {
      final importedPass = await _passService.importPass();

      if (importedPass != null) {
        if (!mounted) return;
        setState(() => _passes = _passService.passes);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pickedFile(importedPass.pass.description))));
      }
      // If fileName is null, the user cancelled the file picker. No action needed.
    } on FormatException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.invalidFileType)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.passParseError)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildPassCard(BuildContext context, PkPass pass) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: ListTile(
        leading: Icon(Icons.airplane_ticket, color: Theme.of(context).colorScheme.primary, size: 40),
        title: Text(pass.pass.logoText ?? 'Pass', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(pass.pass.description),
        trailing: const Icon(Icons.qr_code_scanner),
        onTap: () {
          // TODO: Navigate to pass detail page
        },
      ),
    );
  }
}
