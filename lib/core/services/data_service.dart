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

  /// Exports the provided sets. Handles Web Download vs Mobile Share.
  static Future<void> exportSets(List<VocabSetModel> sets) async {
    try {
      final exportData = {
        'app': _appIdentifier,
        'version': _currentVersion,
        'exportedAt': DateTime.now().toIso8601String(),
        'sets': sets.map((s) => s.toMap()).toList(),
      };

      final jsonString = jsonEncode(exportData);
      final fileName = 'nayza_backup_${DateTime.now().millisecondsSinceEpoch}.json';

      // Use the platform-specific helper
      final helper = getExportHelper();
      await helper.downloadJson(jsonString, fileName);
      
      debugPrint('DataService: Export completed successfully.');
    } catch (e) {
      debugPrint('DataService: Export Error: $e');
      rethrow;
    }
  }

  /// Opens a file picker and parses JSON. Cross-platform support.
  static Future<List<VocabSetModel>> importSets() async {
    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['json'],
        withData: kIsWeb, // Required for Web to get bytes
      );

      if (result == null || result.files.isEmpty) return [];

      String content;
      if (kIsWeb) {
        // WEB: Directly read from bytes
        final bytes = result.files.first.bytes;
        if (bytes == null) throw Exception("Fayl ma'lumotlari bo'sh.");
        content = utf8.decode(bytes);
      } else {
        // MOBILE: Read from path
        final file = File(result.files.first.path!);
        content = await file.readAsString();
      }

      final dynamic decoded = jsonDecode(content);
      final Map<String, dynamic> data = decoded as Map<String, dynamic>;
      if (data['app'] != _appIdentifier) {
        throw Exception('Ushbu fayl Nayza Vocab’ga tegishli emas yoki formati noto\'g\'ri.');
      }

      final List<dynamic> setsJson = (data['sets'] as List<dynamic>?) ?? [];
      final List<VocabSetModel> importedSets = [];
      final uuid = const Uuid();

      for (var sJson in setsJson) {
        final Map<String, dynamic> setMap = Map<String, dynamic>.from(sJson as Map<dynamic, dynamic>);
        final baseSet = VocabSetModel.fromMap(setMap);
        
        final freshSet = VocabSetModel(
          id: uuid.v4(),
          title: '${baseSet.title} (Imported)',
          createdAt: DateTime.now(),
          words: baseSet.words.map((w) => w.copyWith(id: uuid.v4())).toList(),
        );
        
        importedSets.add(freshSet);
      }

      return importedSets;
    } catch (e) {
      debugPrint('DataService: Import Error: $e');
      rethrow;
    }
  }
}
