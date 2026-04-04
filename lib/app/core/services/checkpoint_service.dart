import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

import 'file_service.dart';
import 'isar_service.dart';

class CheckpointInfo {
  final String filePath;
  final DateTime date;
  final int sizeBytes;

  CheckpointInfo({
    required this.filePath,
    required this.date,
    required this.sizeBytes,
  });

  String get formattedDate => DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  String get formattedSize => '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
}

/// CheckpointService — Creates and manages hidden database snapshots
class CheckpointService extends GetxService {
  final FileService _fileService;
  final IsarService _isarService;

  CheckpointService(this._fileService, this._isarService);

  String get _checkpointDir => _fileService.checkpointPath;
  static const int _maxCheckpoints = 2;
  static const int _daysBetweenCheckpoints = 7;

  /// Call on app startup to auto-save a snapshot if 7 days have passed
  Future<void> autoCheckpoint() async {
    try {
      final dir = Directory(_checkpointDir);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final checkpoints = await getCheckpoints();
      
      bool shouldCreate = false;
      if (checkpoints.isEmpty) {
        shouldCreate = true;
      } else {
        // Check if oldest or newest? We check the newest to see if 7 days passed since last save
        final newest = checkpoints.first; // getCheckpoints returns sorted descending
        final daysSinceLast = DateTime.now().difference(newest.date).inDays;
        if (daysSinceLast >= _daysBetweenCheckpoints) {
          shouldCreate = true;
        }
      }

      if (shouldCreate) {
        // Change-detection guard: skip if DB size is unchanged
        final dbDir = Directory(_fileService.databasePath);
        final dbFile = File(p.join(dbDir.path, 'default.isar'));
        if (await dbFile.exists() && checkpoints.isNotEmpty) {
          final currentSize = await dbFile.length();
          if (currentSize == checkpoints.first.sizeBytes) {
            debugPrint('CheckpointService: DB unchanged ($currentSize bytes), skipping checkpoint');
            return;
          }
        }

        debugPrint('CheckpointService: Creating new auto-checkpoint...');
        final dateStamp = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
        final snapshotPath = p.join(_checkpointDir, 'checkpoint_$dateStamp.isar');
        
        await _isarService.isar.copyToFile(snapshotPath);
        debugPrint('CheckpointService: Auto-checkpoint created at $snapshotPath');

        // Prune old checkpoints
        await _pruneCheckpoints();
      }
    } catch (e) {
      debugPrint('CheckpointService: Auto-checkpoint failed - $e');
    }
  }

  /// Get list of all available checkpoints, sorted newest first
  Future<List<CheckpointInfo>> getCheckpoints() async {
    final dir = Directory(_checkpointDir);
    if (!await dir.exists()) return [];

    final List<CheckpointInfo> checkpoints = [];
    final entities = dir.listSync();

    for (final entity in entities) {
      if (entity is File && entity.path.endsWith('.isar')) {
        final stat = await entity.stat();
        checkpoints.add(CheckpointInfo(
          filePath: entity.path,
          date: stat.modified,
          sizeBytes: stat.size,
        ));
      }
    }

    // Sort descending (newest first)
    checkpoints.sort((a, b) => b.date.compareTo(a.date));
    return checkpoints;
  }

  /// Prune older checkpoints to keep only the most recent [_maxCheckpoints]
  Future<void> _pruneCheckpoints() async {
    final checkpoints = await getCheckpoints();
    if (checkpoints.length <= _maxCheckpoints) return;

    // Remove anything past the max count
    for (int i = _maxCheckpoints; i < checkpoints.length; i++) {
      final file = File(checkpoints[i].filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('CheckpointService: Pruned old checkpoint ${file.path}');
      }
    }
  }

  /// Stage a checkpoint for restoration
  Future<bool> restoreFromCheckpoint(String checkpointPath) async {
    try {
      final sourceFile = File(checkpointPath);
      if (!await sourceFile.exists()) return false;

      // 1. Close Isar
      debugPrint('CheckpointService: Closing database for restore...');
      await _isarService.isar.close();

      // 2. Prepare staging directory
      final stagingDir = Directory(_fileService.stagingPath);
      if (await stagingDir.exists()) {
        await stagingDir.delete(recursive: true);
      }
      await stagingDir.create(recursive: true);

      // 3. Copy checkpoint to RestoreStaging/database/default.isar
      final outputDir = Directory(p.join(stagingDir.path, 'database'));
      await outputDir.create(recursive: true);
      
      final outputPath = p.join(outputDir.path, 'default.isar');
      await sourceFile.copy(outputPath);

      // 4. NOTE: We do NOT extract media because checkpoints are DB only.
      // So Media directory stays completely untouched during checkpoint restore!

      debugPrint('CheckpointService: Checkpoint staged successfully. Restart required.');
      return true;
    } catch (e) {
      debugPrint('CheckpointService: Restore failed - $e');
      return false;
    }
  }
}
