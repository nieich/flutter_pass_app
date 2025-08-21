import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A service for saving, loading, and deleting raw .pkpass file bytes
/// from the application's local file storage.
class PassFileStorageService {
  // Singleton setup
  PassFileStorageService._privateConstructor();
  static final PassFileStorageService instance = PassFileStorageService._privateConstructor();

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
}
