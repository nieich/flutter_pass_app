import 'dart:async';

import 'package:flutter_pass_app/services/pass_import_service.dart';
import 'package:passkit/passkit.dart';
import 'package:logging/logging.dart';

import 'pass_file_storage_service.dart';

/// A high-level service that provides parsed [PkPass] models to the app.
/// It orchestrates the file storage and parsing services.
class PassService {
  // --- Singleton Setup ---
  PassService._privateConstructor();
  static final PassService instance = PassService._privateConstructor();
  // ---
  final Logger _logger = Logger('PassService');
  final _storage = PassFileStorageService.instance;
  final _import = PassImportService.instance;

  // A private list to hold the passes in memory.
  List<PkPass> _passes = [];

  /// A public, unmodifiable view of the passes.
  List<PkPass> get passes => List.unmodifiable(_passes);

  /// Initializes the service by loading and parsing all pass files from storage.
  /// Should be called once when the app starts, e.g., in `main()`.
  Future<void> initialize() async {
    await refreshPasses();
  }

  /// Reloads all passes from the file system and parses them.
  ///
  /// This is useful after an import or deletion to update the in-memory list.
  Future<void> refreshPasses() async {
    final passBytesMap = await _storage.loadAllPassFiles();
    final List<PkPass> loadedPasses = [];
    for (var entry in passBytesMap.entries) {
      try {
        // Use the parser to convert the raw bytes into a PkPass model.
        final pass = PkPass.fromBytes(entry.value);
        loadedPasses.add(pass);
      } catch (e, stackTrace) {
        // Log the error for debugging purposes.
        _logger.severe(
          'Failed to parse pass file with serial number: ${entry.key}. It might be corrupt.',
          e,
          stackTrace,
        );
      }
    }

    // Sort passes, for example by organization name, for a consistent order.
    loadedPasses.sort((a, b) => (a.pass.organizationName).compareTo(b.pass.organizationName));
    _passes = loadedPasses;
  }

  /// Import a pass
  ///
  ///
  Future<PkPass?> importPass() async {
    final importResult = await _import.importPassFromFile();
    if (importResult == null) {
      return null;
    }
    await refreshPasses();

    final (importedPass, _) = importResult;
    return importedPass;
  }

  PkPass findPass(String serialNumber) {
    return _passes.firstWhere((pass) => pass.pass.serialNumber == serialNumber);
  }

  /// Removes a pass from the list by its serial number.
  ///
  /// Returns `true` if a pass was removed, `false` otherwise.
  Future<bool> removePass(String serialNumber) async {
    final passExists = _passes.any((p) => p.pass.serialNumber == serialNumber);

    if (passExists) {
      // Remove from file storage first.
      await _storage.deletePassFile(serialNumber);
      // Then remove from the in-memory list.
      _passes.removeWhere((pass) => pass.pass.serialNumber == serialNumber);
      return true;
    }
    return false;
  }

  /// Clears all passes from memory and SharedPreferences.
  Future<void> clearAllPasses() async {
    _passes = [];
    await _storage.deleteAllPassFiles();
  }
}
