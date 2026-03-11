import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

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



  /// Get path to the showroom logo
  Future<String> getShowroomLogoPath() async {
    final path = p.join(mediaPath, 'Settings');
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return p.join(path, 'logo.jpg');
  }

  /// Save showroom logo
  Future<String?> saveShowroomLogo(File sourceFile) async {
    try {
      final logoPath = await getShowroomLogoPath();
      final savedFile = await sourceFile.copy(logoPath);
      return savedFile.path;
    } catch (e) {
      debugPrint('Error saving showroom logo: $e');
      return null;
    }
  }

  // --- Supplier Media ---

  String get suppliersMediaPath => p.join(mediaPath, 'Suppliers');

  /// Get (and create) the path for a supplier's media folder
  Future<String> getSupplierBasePath(String supplierName) async {
    final sanitized = supplierName.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    final path = p.join(suppliersMediaPath, sanitized);
    
    final directory = Directory(path);
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
    return path;
  }

  Future<void> deleteSupplierDirectory(String supplierName) async {
    final sanitized = supplierName.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    final path = p.join(suppliersMediaPath, sanitized);
    final directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<void> renameSupplierDirectory(String oldName, String newName) async {
    final oldSanitized = oldName.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    final newSanitized = newName.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    
    if (oldSanitized == newSanitized) return; // No change in folder name

    final oldPath = p.join(suppliersMediaPath, oldSanitized);
    final newPath = p.join(suppliersMediaPath, newSanitized);
    
    final oldDir = Directory(oldPath);
    if (await oldDir.exists()) {
      await oldDir.rename(newPath);
    }
  }

  /// Save supplier profile picture
  /// Path: Media/Suppliers/{Name}/Profile/profile.jpg
  Future<String> saveSupplierProfile(File sourceFile, String supplierName) async {
    final basePath = await getSupplierBasePath(supplierName);
    final profilePath = p.join(basePath, 'Profile');
    
    if (!await Directory(profilePath).exists()) {
      await Directory(profilePath).create(recursive: true);
    }

    final extension = p.extension(sourceFile.path);
    final filename = 'profile$extension';
    final destPath = p.join(profilePath, filename);
    
    await sourceFile.copy(destPath);
    return filename; // We only store filename, logic knows it's in Profile/
  }

  /// Save supplier CNIC picture
  /// Path: Media/Suppliers/{Name}/CNIC/cnic.jpg
  Future<String> saveSupplierCnic(File sourceFile, String supplierName) async {
    final basePath = await getSupplierBasePath(supplierName);
    final cnicPath = p.join(basePath, 'CNIC');
    
    if (!await Directory(cnicPath).exists()) {
      await Directory(cnicPath).create(recursive: true);
    }

    final extension = p.extension(sourceFile.path);
    final filename = 'cnic$extension';
    final destPath = p.join(cnicPath, filename);
    
    await sourceFile.copy(destPath);
    return filename;
  }

  /// Save purchase batch invoice image
  /// Path: Media/Suppliers/{Name}/{YYYY-MM-DD}/inv_{batchId}.jpg
  Future<String> saveInvoiceImage(File sourceFile, String supplierName, String batchId) async {
    final basePath = await getSupplierBasePath(supplierName);
    
    // Create Date Folder
    final now = DateTime.now();
    final dateFolder = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final invoicePath = p.join(basePath, dateFolder);

    if (!await Directory(invoicePath).exists()) {
      await Directory(invoicePath).create(recursive: true);
    }

    final extension = p.extension(sourceFile.path);
    final filename = 'inv_$batchId$extension'; // Filename
    // Store relative path from Supplier Base for easier retrieval or just use logic?
    // User asked for "one dated folder of sales that have receipt".
    // We will return the relative path from the Supplier Base so we can find it later easily,
    // OR we just store the filename and reconstructed the path if we have the date?
    // PurchaseBatch model has `billImageFilename`.
    // It has `purchaseDate`.
    // So we can reconstruct `Suppliers/{Name}/{Date}/Filename`.
    
    final destPath = p.join(invoicePath, filename);
    await sourceFile.copy(destPath);
    return filename;
  }

  // --- Retrievers ---

  Future<String> getSupplierProfilePath(String supplierName, String filename) async {
    final basePath = await getSupplierBasePath(supplierName);
    return p.join(basePath, 'Profile', filename);
  }

  Future<String> getSupplierCnicPath(String supplierName, String filename) async {
    final basePath = await getSupplierBasePath(supplierName);
    return p.join(basePath, 'CNIC', filename);
  }

  Future<String> getInvoiceImagePath(String supplierName, DateTime date, String filename) async {
    final basePath = await getSupplierBasePath(supplierName);
    final dateFolder = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return p.join(basePath, dateFolder, filename);
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

  /// Rename a batch directory when the date changes
  Future<void> renameBatchDirectory(String supplierName, DateTime oldDate, DateTime newDate) async {
    final basePath = await getSupplierBasePath(supplierName);
    final oldFolderName = '${oldDate.year}-${oldDate.month.toString().padLeft(2, '0')}-${oldDate.day.toString().padLeft(2, '0')}';
    final newFolderName = '${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';

    final oldPath = p.join(basePath, oldFolderName);
    final newPath = p.join(basePath, newFolderName);

    if (oldPath != newPath && await Directory(oldPath).exists()) {
       await Directory(oldPath).rename(newPath);
    }
  }

  /// Delete a batch directory
  Future<void> deleteBatchDirectory(String supplierName, DateTime date) async {
    final basePath = await getSupplierBasePath(supplierName);
    final folderName = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final path = p.join(basePath, folderName);

    if (await Directory(path).exists()) {
      await Directory(path).delete(recursive: true);
    }
  }

  /// Get full path to a bike image from just the filename
  String getBikeImagePath(String filename) {
    return p.join(bikesMediaPath, filename);
  }

  /// Get full path to a customer profile image from filename and CNIC
  String getCustomerProfileImagePath(String filename, String cnic) {
    final sanitizedCnic = cnic.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    return p.join(customersMediaPath, sanitizedCnic, filename);
  }

  /// Get full path to a witness CNIC image from filename and customer CNIC
  String getWitnessCnicImagePath(String filename, String customerCnic) {
    final sanitizedCnic = customerCnic.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    return p.join(customersMediaPath, sanitizedCnic, 'Witness', filename);
  }

  /// Get full path to a supplier profile image synchronously
  String getSupplierProfileImagePathSync(String filename, String supplierName) {
    final sanitized = supplierName.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '');
    return p.join(suppliersMediaPath, sanitized, 'Profile', filename);
  }

  /// Pick an image from gallery/filesystem
  Future<File?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }
}

// Authored by: Moazzam Samoo
