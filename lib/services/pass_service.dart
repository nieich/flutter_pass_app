import 'dart:async';

import 'package:flutter_pass_app/services/pass_import_service.dart';
import 'package:http/http.dart' as http;
import 'package:passkit/passkit.dart';
import 'package:logging/logging.dart';

import 'pass_file_storage_service.dart';

/// An abstract interface for a high-level service that provides parsed
/// [PkPass] models to the app. It orchestrates the file storage, import,
/// and parsing services.
abstract class PassService {
  /// A public, unmodifiable view of the passes.
  List<PkPass> get passes;

  /// Initializes the service by loading and parsing all pass files from storage.
  Future<void> initialize();

  /// Reloads all passes from the file system and parses them.
  Future<void> refreshPasses();

  /// Imports a pass from a file and adds it to the collection.
  Future<PkPass?> importPass();

  /// Finds a pass by its serial number.
  PkPass findPass(String serialNumber);

  /// Attempts to update all passes that have a web service URL.
  Future<void> updateAllPasses();

  /// Attempts to update a single pass by its serial number.
  Future<PkPass?> updatePass(String serialNumber);

  /// Removes a pass from storage and memory by its serial number.
  Future<bool> deletePass(String serialNumber);

  /// Clears all passes from memory and storage.
  Future<void> clearAllPasses();
}

/// A concrete implementation of [PassService].
class PassServiceImpl implements PassService {
  final Logger _logger = Logger('PassService');
  final PassFileStorageService _storage;
  final PassImportService _import;
  List<PkPass> _passes = [];

  PassServiceImpl(this._storage, this._import);

  @override
  List<PkPass> get passes => List.unmodifiable(_passes);

  @override
  Future<void> initialize() async {
    await refreshPasses();
    await updateAllPasses();
  }

  @override
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

  @override
  Future<PkPass?> importPass() async {
    final importResult = await _import.importPassFromFile();
    if (importResult == null) {
      return null;
    }

    await refreshPasses();

    final (importedPass, _) = importResult;
    return importedPass;
  }

  @override
  PkPass findPass(String serialNumber) {
    return _passes.firstWhere((pass) => pass.pass.serialNumber == serialNumber);
  }

  @override
  Future<void> updateAllPasses() async {
    for (final pass in _passes) {
      await updatePass(pass.pass.serialNumber);
    }
  }

  @override
  Future<PkPass?> updatePass(String serialNumber) async {
    final oldPass = findPass(serialNumber);

    if (oldPass.isWebServiceAvailable == false) {
      _logger.info('Pass cant update');
      return oldPass;
    }

    if (oldPass.pass.expirationDate != null && oldPass.pass.expirationDate!.isBefore(DateTime.now())) {
      _logger.info('Pass expired');
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

  @override
  Future<bool> deletePass(String serialNumber) async {
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

  @override
  Future<void> clearAllPasses() async {
    _passes = [];
    await _storage.deleteAllPassFiles();
  }
}
