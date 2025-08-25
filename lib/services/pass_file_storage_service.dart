import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:passkit/passkit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A service for saving, loading, and deleting raw .pkpass file bytes
/// from the application's local file storage.
class PassFileStorageService {
  // Singleton setup
  PassFileStorageService._privateConstructor();
  static final PassFileStorageService instance = PassFileStorageService._privateConstructor();

  static final logger = Logger('PassFileStorageService');

  static const _passDirectory = 'passes';

  /// Returns the directory where passes are stored.
  Future<Directory> _getPassesDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final passesDir = Directory(p.join(appDir.path, _passDirectory));
    // Create the directory if it doesn't exist.
    if (!await passesDir.exists()) {
      await passesDir.create(recursive: true);
    }
    return passesDir;
  }

  /// Saves the bytes of a .pkpass file. The filename is the serial number.
  Future<File> savePassFile({required String serialNumber, required Uint8List bytes}) async {
    final dir = await _getPassesDirectory();
    final file = File(p.join(dir.path, '$serialNumber.pkpass'));
    return file.writeAsBytes(bytes);
  }

  /// Loads all .pkpass files from storage.
  ///
  /// Returns a map where the key is the serial number (filename without extension)
  /// and the value is the file's byte content.
  Future<Map<String, Uint8List>> loadAllPassFiles() async {
    final dir = await _getPassesDirectory();
    final Map<String, Uint8List> passFiles = {};

    if (!await dir.exists()) return passFiles;

    final entities = dir.listSync();
    for (var entity in entities) {
      if (entity is File && p.extension(entity.path) == '.pkpass') {
        final serialNumber = p.basenameWithoutExtension(entity.path);
        final bytes = await entity.readAsBytes();
        passFiles[serialNumber] = bytes;
      }
    }
    return passFiles;
  }

  Future<Uint8List> loadPassFile(String serialNumber) async {
    final dir = await _getPassesDirectory();
    final file = File(p.join(dir.path, '$serialNumber.pkpass'));
    return file.readAsBytes();
  }

  /// Deletes a pass file by its serial number.
  Future<void> deletePassFile(String serialNumber) async {
    final dir = await _getPassesDirectory();
    final file = File(p.join(dir.path, '$serialNumber.pkpass'));

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes all pass files from storage.
  Future<void> deleteAllPassFiles() async {
    final dir = await _getPassesDirectory();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  // This function will automatically update a pkpass file stored on the device.
  // It reads the existing pass, extracts the service URL and auth token,
  // fetches the new version, and overwrites the old file.
  Future<void> updatePkpass(PkPass pkpass) async {
    if (pkpass.isWebServiceAvailable == false) {
      logger.info('Pass cant update');
      return;
    }
    try {
      final webServiceURL = pkpass.pass.webServiceURL!;
      final authToken = pkpass.pass.authenticationToken!;
      final passTypeIdentifier = pkpass.pass.passTypeIdentifier;
      final serialNumber = pkpass.pass.serialNumber;

      logger.info('Found webServiceURL: $webServiceURL');
      logger.info('Found authenticationToken: $authToken');

      final uri = Uri.parse('$webServiceURL/v1/passes/$passTypeIdentifier/$serialNumber');

      // 3. Make an HTTP request to the web service URL to get the latest pass
      final response = await http.get(uri, headers: {'Authorization': 'ApplePass $authToken'});

      // Check if the response is a successful update
      if (response.statusCode == 200) {
        // 4. Overwrite the old file with the new pkpass data
        await savePassFile(serialNumber: serialNumber, bytes: response.bodyBytes);
        logger.info('Successfully updated the pkpass file!');
      } else if (response.statusCode == 304) {
        logger.info('PKPass is already up to date (HTTP 304 Not Modified).');
      } else {
        logger.warning('Failed to update PKPass. Status code: ${response.statusCode}');
        logger.warning('Response body: ${response.body}');
      }
    } catch (e) {
      logger.severe('An error occurred during PKPass update: $e');
    }
  }
}
