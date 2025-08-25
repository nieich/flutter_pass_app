import 'dart:async';

import 'package:flutter_pass_app/services/pass_import_service.dart';
import 'package:http/http.dart' as http;
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
    await updateAllPasses();
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
        //  skipSignatureVerification: might be needed when pass is older
        final pass = PkPass.fromBytes(entry.value, skipSignatureVerification: true);
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

  Future<void> updateAllPasses() async {
    for (final pass in _passes) {
      await updatePass(pass.pass.serialNumber);
    }
  }

  Future<PkPass?> updatePass(String serialNumber) async {
    final bytes = await _storage.loadPassFile(serialNumber);
    final oldPass = PkPass.fromBytes(bytes);

    if (oldPass.isWebServiceAvailable == false) {
      _logger.info('Pass cant update');
      return oldPass;
    }
    try {
      final webServiceURL = oldPass.pass.webServiceURL!;
      final authToken = oldPass.pass.authenticationToken!;
      final passTypeIdentifier = oldPass.pass.passTypeIdentifier;
      final serialNumber = oldPass.pass.serialNumber;

      _logger.info('Found webServiceURL: $webServiceURL');
      _logger.info('Found authenticationToken: $authToken');

      final uri = Uri.parse('$webServiceURL/v1/passes/$passTypeIdentifier/$serialNumber');

      // 3. Make an HTTP request to the web service URL to get the latest pass
      final response = await http.get(uri, headers: {'Authorization': 'ApplePass $authToken'});

      // Check if the response is a successful update
      if (response.statusCode == 200) {
        // 4. Overwrite the old file with the new pkpass data
        await _storage.savePassFile(serialNumber: serialNumber, bytes: response.bodyBytes);
        refreshPasses();
        _logger.info('Successfully updated the pkpass file!');
        return PkPass.fromBytes(response.bodyBytes);
      } else if (response.statusCode == 304) {
        _logger.info('PKPass is already up to date (HTTP 304 Not Modified).');
      } else {
        _logger.warning('Failed to update PKPass. Status code: ${response.statusCode}');
        _logger.warning('Response body: ${response.body}');
      }
    } catch (e) {
      _logger.severe('An error occurred during PKPass update: $e');
    }
    return oldPass;
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
