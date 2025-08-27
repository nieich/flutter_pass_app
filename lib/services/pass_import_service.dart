import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pass_app/services/pass_file_storage_service.dart';
import 'package:passkit/passkit.dart';

/// An exception thrown when the user selects a file that is not a .pkpass file.
class InvalidFileTypeException implements Exception {
  final String message;
  InvalidFileTypeException(this.message);
  @override
  String toString() => message;
}

/// An exception thrown when there's an error parsing the .pkpass file.
class PassParsingException implements Exception {
  final String message;
  PassParsingException(this.message);
  @override
  String toString() => message;
}

/// An exception thrown for unexpected errors during the import process.
class PassImportFailedException implements Exception {
  final String message;
  PassImportFailedException(this.message);
  @override
  String toString() => message;
}

/// An abstract interface for a service that handles the workflow of importing a
/// .pkpass file.
abstract class PassImportService {
  /// Opens a file picker for the user to select a .pkpass file.
  /// Returns `null` if the user cancels the file picker.
  /// Throws [InvalidFileTypeException] if the file is not a .pkpass.
  /// Throws [PassParsingException] if parsing fails.
  /// Throws other exceptions for unexpected errors during the process.
  Future<(PkPass, String)?> importPassFromFile();
}

/// A concrete implementation of [PassImportService].
class PassImportServiceImpl implements PassImportService {
  final PassFileStorageService _storageService;

  PassImportServiceImpl(this._storageService);

  // Define a constant for the .pkpass file extension
  static const String _pkpassExtension = 'pkpass';

  @override
  Future<(PkPass, String)?> importPassFromFile() async {
    try {
      // 1. Let the user pick a .pkpass file.
      final file = await _pickFile();

      // This should not happen if the picker wasn't cancelled, but it's a good safeguard.
      if (file == null) {
        return null;
      }

      final filePath = file.path;

      // This should not happen if the picker wasn't cancelled, but it's a good safeguard.
      if (filePath == null) {
        return null;
      }

      // 2. Read file bytes from path
      if (file.extension?.toLowerCase() != _pkpassExtension) {
        throw InvalidFileTypeException('Invalid file type. Please select a .pkpass file.');
      }

      // 2. Read file bytes from path.
      final Uint8List fileBytes = await File(filePath).readAsBytes();

      // 3. Parse the file to get the serial number for the filename.
      final pass = _parsePass(fileBytes);

      // 4. Save the original file bytes using the storage service.
      await _storageService.savePassFile(serialNumber: pass.pass.serialNumber, bytes: fileBytes);

      return (pass, file.name);
    } on InvalidFileTypeException {
      // Re-throw the specific exception to be handled by the UI.
      rethrow;
    } on PassParsingException catch (e) {
      // Catch specific PkPass parsing errors
      throw PassParsingException('Failed to parse the .pkpass file: ${e.message}');
    } catch (e, s) {
      // General catch-all for anything not caught by specific Exception
      // Catch any other unexpected errors during the process.
      if (kDebugMode) {
        debugPrint('Error importing pass: $e\n$s');
      }
      // Rethrow a generic exception to be shown to the user.
      throw PassImportFailedException('An unexpected error occurred while importing the pass.');
    }
  }

  /// Opens a file picker for the user to select a .pkpass file.
  Future<PlatformFile?> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [_pkpassExtension],
      withData: false, // More memory efficient, we'll read from the path.
    );

    return result?.files.single;
  }

  /// Parses the pass data from bytes.
  PkPass _parsePass(Uint8List bytes) {
    // Skipping verification is faster and avoids needing certificates just for import.
    return PkPass.fromBytes(bytes, skipChecksumVerification: true, skipSignatureVerification: true);
  }
}
