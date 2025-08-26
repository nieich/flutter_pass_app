import 'dart:io';
import 'dart:typed_data';

import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// An abstract interface for a service that handles storing, loading, and
/// deleting raw .pkpass files from the device's local storage.
///
/// This abstraction allows for easier testing by enabling mock implementations.
abstract class PassFileStorageService {
  /// Saves the bytes of a .pkpass file. The filename is the serial number.
  Future<File> savePassFile({required String serialNumber, required Uint8List bytes});

  /// Loads all .pkpass files from storage.
  Future<Map<String, Uint8List>> loadAllPassFiles();

  /// Loads a single .pkpass file by its serial number.
  Future<Uint8List> loadPassFile(String serialNumber);

  /// Deletes a pass file by its serial number.
  Future<void> deletePassFile(String serialNumber);

  /// Deletes all pass files from storage.
  Future<void> deleteAllPassFiles();
}

/// A concrete implementation of [PassFileStorageService] that uses the
/// local file system for storage.
class PassFileStorageServiceImpl implements PassFileStorageService {
  static final logger = Logger('PassFileStorageService');

  static const _passDirectory = 'passes';

  Directory? _passesDirectory;

  /// Returns the directory where passes are stored.
  Future<Directory> _getPassesDirectory() async {
    if (_passesDirectory != null) return _passesDirectory!;
    final appDir = await getApplicationDocumentsDirectory();
    final passesDir = Directory(p.join(appDir.path, _passDirectory));
    // Create the directory if it doesn't exist.
    if (!await passesDir.exists()) {
      await passesDir.create(recursive: true);
    }
    return _passesDirectory = passesDir;
  }

  /// Saves the bytes of a .pkpass file. The filename is the serial number.
  @override
  Future<File> savePassFile({required String serialNumber, required Uint8List bytes}) async {
    final dir = await _getPassesDirectory();
    final file = File(p.join(dir.path, '$serialNumber.pkpass'));
    return file.writeAsBytes(bytes);
  }

  /// Loads all .pkpass files from storage.
  ///
  /// Returns a map where the key is the serial number (filename without extension)
  /// and the value is the file's byte content.
  @override
  Future<Map<String, Uint8List>> loadAllPassFiles() async {
    final dir = await _getPassesDirectory();
    if (!await dir.exists()) {
      return {};
    }

    final files = await dir
        .list()
        .where((entity) => entity is File && p.extension(entity.path) == '.pkpass')
        .cast<File>()
        .toList();

    if (files.isEmpty) {
      return {};
    }

    final List<Future<Uint8List>> readFutures = files.map((f) => f.readAsBytes()).toList();
    final List<Uint8List> allBytes = await Future.wait(readFutures);

    final Map<String, Uint8List> passFiles = {};
    for (var i = 0; i < files.length; i++) {
      final serialNumber = p.basenameWithoutExtension(files[i].path);
      passFiles[serialNumber] = allBytes[i];
    }
    return passFiles;
  }

  @override
  Future<Uint8List> loadPassFile(String serialNumber) async {
    final dir = await _getPassesDirectory();
    final file = File(p.join(dir.path, '$serialNumber.pkpass'));
    return file.readAsBytes();
  }

  /// Deletes a pass file by its serial number.
  @override
  Future<void> deletePassFile(String serialNumber) async {
    final dir = await _getPassesDirectory();
    final file = File(p.join(dir.path, '$serialNumber.pkpass'));

    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes all pass files from storage.
  @override
  Future<void> deleteAllPassFiles() async {
    final dir = await _getPassesDirectory();
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
