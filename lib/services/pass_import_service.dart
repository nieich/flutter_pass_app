import 'package:file_picker/file_picker.dart';
import 'package:flutter_pass_app/services/pass_file_storage_service.dart';
import 'package:passkit/passkit.dart';

/// An exception thrown when the user selects a file that is not a .pkpass file.
class InvalidFileTypeException implements Exception {
  final String message;
  InvalidFileTypeException(this.message);
  @override
  String toString() => message;
}

/// A service that handles the entire workflow of importing a .pkpass file.
class PassImportService {
  // Singleton setup
  PassImportService._privateConstructor();
  static final PassImportService instance = PassImportService._privateConstructor();

  final _storageService = PassFileStorageService.instance;

  /// Opens a file picker, lets the user choose a .pkpass file,
  /// parses it, and saves it to local storage.
  ///
  /// Returns a tuple containing the imported [PKPass] and the original
  /// file name on success.
  /// Returns `null` if the user cancels the file picker.
  /// Throws [InvalidFileTypeException] if the file is not a .pkpass.
  /// Throws other exceptions if parsing or saving fails.
  Future<(PkPass, String)?> importPassFromFile() async {
    // 1. Let the user pick a file.
    final result = await FilePicker.platform.pickFiles(type: FileType.any, withData: true);

    // Return null if the user cancelled the picker.
    if (result == null || result.files.single.bytes == null) {
      return null;
    }

    final file = result.files.single;

    // 2. Validate the file type.
    if (file.extension?.toLowerCase() != 'pkpass') {
      throw InvalidFileTypeException('Invalid file type. Please select a .pkpass file.');
    }

    // 3. Parse the file to get the serial number for the filename.
    final pass = PkPass.fromBytes(file.bytes!, skipChecksumVerification: true, skipSignatureVerification: true);

    // 4. Save the original file bytes using the new storage service.
    await _storageService.savePassFile(serialNumber: pass.pass.serialNumber, bytes: file.bytes!);

    return (pass, file.name);
  }
}
