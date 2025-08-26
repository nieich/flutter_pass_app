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

/// An abstract interface for a service that handles the workflow of importing a
/// .pkpass file.
abstract class PassImportService {
  /// Opens a file picker for the user to select a .pkpass file.
  /// Returns `null` if the user cancels the file picker.
  /// Throws [InvalidFileTypeException] if the file is not a .pkpass.
  /// Throws other exceptions if parsing or saving fails.
  Future<(PkPass, String)?> importPassFromFile();
}

/// A concrete implementation of [PassImportService].
class PassImportServiceImpl implements PassImportService {
  final PassFileStorageService _storageService;

  PassImportServiceImpl(this._storageService);

  @override
  Future<(PkPass, String)?> importPassFromFile() async {
    try {
      // 1. Let the user pick a file, restricting to .pkpass for better UX.
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: false, // More memory efficient, we'll read from the path.
      );

      // Return null if the user cancelled the picker.
      if (result == null || result.files.isEmpty) {
        return null;
      }

      final file = result.files.single;
      final filePath = file.path;

      // This should not happen if the picker wasn't cancelled, but it's a good safeguard.
      if (filePath == null) {
        return null;
      }

      // 2. Validate the file type (double-check).
      // The picker should handle this, but it's good practice to verify.
      if (file.extension?.toLowerCase() != 'pkpass') {
        throw InvalidFileTypeException('Invalid file type. Please select a .pkpass file.');
      }

      // 3. Read file bytes from path. This is more memory-efficient than `withData: true`.
      final Uint8List fileBytes = await File(filePath).readAsBytes();

      // 4. Parse the file to get the serial number for the filename.
      // Skipping verification is faster and avoids needing certificates just for import.
      final pass = PkPass.fromBytes(fileBytes, skipChecksumVerification: true, skipSignatureVerification: true);

      // 5. Save the original file bytes using the storage service.
      await _storageService.savePassFile(serialNumber: pass.pass.serialNumber, bytes: fileBytes);

      return (pass, file.name);
    } on InvalidFileTypeException {
      // Re-throw the specific exception to be handled by the UI.
      rethrow;
    } catch (e, s) {
      // Catch any other unexpected errors during the process.
      if (kDebugMode) {
        debugPrint('Error importing pass: $e\n$s');
      }
      // Rethrow a generic exception to be shown to the user.
      throw Exception('An unexpected error occurred while importing the pass.');
    }
  }
}
