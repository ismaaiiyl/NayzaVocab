import 'export_helper/export_helper.dart'
    if (dart.library.html) 'export_helper/web_export_helper.dart'
    if (dart.library.io) 'export_helper/mobile_export_helper.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:file_picker/file_picker.dart' as fp;
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show File;

class DataService {
  static const String _appIdentifier = 'NayzaVocab_Backup';
  static const int _currentVersion = 1;

  /// Exports the provided sets and optional folders as JSON.
  static Future<void> exportSets(List<VocabSetModel> sets, {List<dynamic>? folders}) async {
    try {
      final exportData = {
        'app': _appIdentifier,
        'version': _currentVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'sets': sets.map((s) => s.toMap()).toList(),
        'folders': folders, // Optional: folders mapping
      };

      final jsonString = jsonEncode(exportData);
      final fileName = 'nayza_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      final helper = getExportHelper();
      await helper.downloadJson(jsonString, fileName);
      
      debugPrint('DataService: Export completed successfully.');
    } catch (e) {
      debugPrint('DataService: Export Error: $e');
      rethrow;
    }
  }

  /// Shares a single set using the standard JSON backup format.
  static Future<void> shareSingleSet(VocabSetModel set, {required String subject, required String message}) async {
    try {
      final exportData = {
        'app': _appIdentifier,
        'version': _currentVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'sets': [set.toMap()], // Wrapped as a single-set backup
      };

      final String jsonString = jsonEncode(exportData);
      
      final safeTitle = set.title.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
      final fileName = 'nayza_$safeTitle.json';

      final helper = getExportHelper();
      await helper.shareFile(jsonString, fileName, subject, message);

      debugPrint('DataService: Single set shared successfully as JSON.');
    } catch (e) {
      debugPrint('DataService: Share Single Set Error: $e');
      rethrow;
    }
  }

  /// Opens a file picker and parses JSON backup files.
  /// Returns a Map with 'sets' and optionally 'folders'.
  static Future<Map<String, dynamic>> importData({required String importedSuffix}) async {
    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['json'],
        withData: kIsWeb,
      );

      if (result == null || result.files.isEmpty) return {};

      String content;
      if (kIsWeb) {
        final bytes = result.files.first.bytes;
        if (bytes == null) throw Exception("Fayl ma'lumotlari bo'sh.");
        content = utf8.decode(bytes);
      } else {
        final file = File(result.files.first.path!);
        content = await file.readAsString();
      }

      final uuid = const Uuid();
      final dynamic decoded = jsonDecode(content);
      if (decoded is! Map<String, dynamic>) throw Exception('Noto\'g\'ri format.');
      
      final Map<String, dynamic> data = decoded;
      
      if (data['app'] != _appIdentifier) {
        throw Exception('Ushbu fayl Nayza Vocab’ga tegishli emas yoki formati noto\'g\'ri.');
      }

      final List<dynamic> setsJson = (data['sets'] as List<dynamic>?) ?? [];
      final List<dynamic> foldersJson = (data['folders'] as List<dynamic>?) ?? [];
      
      final List<VocabSetModel> importedSets = [];
      final Map<String, String> folderIdMapping = {}; // Old ID -> New ID

      // 1. Process Folders first
      for (var fJson in foldersJson) {
        final Map<String, dynamic> fMap = Map<String, dynamic>.from(fJson as Map<dynamic, dynamic>);
        final oldId = fMap['id'] as String;
        final newId = uuid.v4();
        folderIdMapping[oldId] = newId;
        
        fMap['id'] = newId;
        fMap['title'] = '${fMap['title']} $importedSuffix';
      }

      // 2. Process Sets
      for (var sJson in setsJson) {
        final Map<String, dynamic> setMap = Map<String, dynamic>.from(sJson as Map<dynamic, dynamic>);
        final baseSet = VocabSetModel.fromMap(setMap);
        
        final oldFolderId = setMap['folderId'] as String?;
        final newFolderId = oldFolderId != null ? folderIdMapping[oldFolderId] : null;

        final freshSet = VocabSetModel(
          id: uuid.v4(),
          title: '${baseSet.title} $importedSuffix',
          createdAt: DateTime.now(),
          words: baseSet.words.map((w) => w.copyWith(id: uuid.v4())).toList(),
          folderId: newFolderId,
        );
        
        importedSets.add(freshSet);
      }

      return {
        'sets': importedSets,
        'folders': foldersJson, // These now have new IDs and titles
      };
    } catch (e) {
      debugPrint('DataService: Import Error: $e');
      rethrow;
    }
  }
}
