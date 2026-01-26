import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// FileService - Handles Windows file system operations
/// 
/// Creates and manages the TahirShowroom directory structure in Documents:
/// TahirShowroom/
/// ├── Database/
/// └── Media/
///     ├── Bikes/
///     └── Customers/
class FileService extends GetxService {
  late String _rootPath;
  
  String get rootPath => _rootPath;
  String get databasePath => p.join(_rootPath, 'Database');
  String get mediaPath => p.join(_rootPath, 'Media');
  String get bikesMediaPath => p.join(mediaPath, 'Bikes');
  String get customersMediaPath => p.join(mediaPath, 'Customers');

  /// Initialize the file service and create directory structure
  Future<FileService> init() async {
    // Get Documents directory
    final documentsDir = await getApplicationDocumentsDirectory();
    _rootPath = p.join(documentsDir.path, 'TahirShowroom');
    
    // Create directory structure
    await _createDirectoryStructure();
    
    return this;
  }

  /// Creates the required directory structure if it doesn't exist
  Future<void> _createDirectoryStructure() async {
    final directories = [
      _rootPath,
      databasePath,
      mediaPath,
      bikesMediaPath,
      customersMediaPath,
    ];

    for (final dir in directories) {
      final directory = Directory(dir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
    }
  }

  /// Get the path for a customer's media folder (created by CNIC)
  Future<String> getCustomerMediaPath(String cnic) async {
    // Sanitize CNIC for folder name (remove special characters)
    final sanitizedCnic = cnic.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    final customerPath = p.join(customersMediaPath, sanitizedCnic);
    
    final directory = Directory(customerPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    return customerPath;
  }

  /// Get the path for a customer's witness folder
  Future<String> getWitnessMediaPath(String customerCnic) async {
    final customerPath = await getCustomerMediaPath(customerCnic);
    final witnessPath = p.join(customerPath, 'Witness');
    
    final directory = Directory(witnessPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    return witnessPath;
  }

  /// Save a bike image to Media/Bikes/[engineNumber].ext
  Future<String> saveBikeImage(File sourceFile, String engineNumber) async {
    final extension = p.extension(sourceFile.path);
    final filename = 'bike_$engineNumber$extension';
    final destPath = p.join(bikesMediaPath, filename);
    
    await sourceFile.copy(destPath);
    
    return filename;
  }

  /// Save a customer image (profile, cnic_front, cnic_back)
  Future<String> saveCustomerImage(
    File sourceFile,
    String cnic,
    String imageType,
  ) async {
    final customerPath = await getCustomerMediaPath(cnic);
    final extension = p.extension(sourceFile.path);
    final filename = '$imageType$extension';
    final destPath = p.join(customerPath, filename);
    
    await sourceFile.copy(destPath);
    
    return filename;
  }

  /// Save a witness image
  Future<String> saveWitnessImage(
    File sourceFile,
    String customerCnic,
    int witnessIndex,
  ) async {
    final witnessPath = await getWitnessMediaPath(customerCnic);
    final extension = p.extension(sourceFile.path);
    final filename = 'witness${witnessIndex}_cnic$extension';
    final destPath = p.join(witnessPath, filename);
    
    await sourceFile.copy(destPath);
    
    return filename;
  }

  /// Get the full path for a bike image
  String getBikeImagePath(String filename) {
    return p.join(bikesMediaPath, filename);
  }

  /// Get the full path for a customer image
  String getCustomerImagePath(String cnic, String filename) {
    final sanitizedCnic = cnic.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    return p.join(customersMediaPath, sanitizedCnic, filename);
  }

  /// Get the full path for a witness image
  String getWitnessImagePath(String customerCnic, String filename) {
    final sanitizedCnic = customerCnic.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    return p.join(customersMediaPath, sanitizedCnic, 'Witness', filename);
  }

  /// Check if a file exists
  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  /// Delete a file
  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

// Authored by: Moazzam Samoo
