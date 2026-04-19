import 'export_helper/export_helper.dart'
    if (dart.library.html) 'export_helper/web_export_helper.dart'
    if (dart.library.io) 'export_helper/mobile_export_helper.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:file_picker/file_picker.dart' as fp;
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show File;
import 'package:csv/csv.dart';

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

  /// Bitta to'plamni ulashish uchun (Smart Share) CSV ko'rinishida yuboradi
  static Future<void> shareSingleSet(VocabSetModel set, {required String subject, required String message}) async {
    try {
      // 1. CSV uchun ma'lumotlarni tayyorlaymiz (Katalog sarlavhalari bilan)
      List<List<dynamic>> csvData = [
        ['Original Word', 'Translation'],
      ];

      for (var word in set.words) {
        csvData.add([word.original, word.translation]);
      }

      final String csvString = csv.encode(csvData);
      
      // Bo'sh joylarni tozalab chiroyli fayl nomi yaratamiz
      final safeTitle = set.title.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
      final fileName = 'nayza_${safeTitle}.csv';

      final helper = getExportHelper();
      await helper.shareFile(csvString, fileName, subject, message);

      debugPrint('DataService: Single set shared successfully as CSV.');
    } catch (e) {
      debugPrint('DataService: Share Single Set Error: $e');
      rethrow;
    }
  }

  /// Opens a file picker and parses JSON or CSV.
  static Future<List<VocabSetModel>> importSets({required String importedSuffix}) async {
    try {
      final result = await fp.FilePicker.platform.pickFiles(
        type: fp.FileType.custom,
        allowedExtensions: ['json', 'csv'],
        withData: kIsWeb, // Required for Web to get bytes
      );

      if (result == null || result.files.isEmpty) return [];

      final fileExt = result.files.first.extension?.toLowerCase();
      String content;
      
      if (kIsWeb) {
        final bytes = result.files.first.bytes;
        if (bytes == null) throw Exception("Fayl ma'lumotlari bo'sh.");
        content = utf8.decode(bytes);
      } else {
        final file = File(result.files.first.path!);
        content = await file.readAsString();
      }

      final List<VocabSetModel> importedSets = [];
      final uuid = const Uuid();

      if (fileExt == 'csv') {
        // --- CSV IMPORT LOGIC ---
        final List<List<dynamic>> csvTable = csv.decode(content);
        if (csvTable.isEmpty) throw Exception("CSV fayli bo'sh.");

        // Fayl nomini title sifatida olamiz (extensiyonsiz)
        String rawName = result.files.first.name;
        String title = rawName.contains('.') ? rawName.substring(0, rawName.lastIndexOf('.')) : rawName;
        // Agar "nayza_" bilan boshlangan bo'lsa olib tashlaymiz
        if (title.startsWith('nayza_')) title = title.replaceFirst('nayza_', '');

        final List<WordModel> words = [];
        
        // Birinchi qator sarlavha (Header) deb hisoblasak bo'ladimi? 
        // Oddiy tekshiramiz
        int startIndex = 0;
        if (csvTable.length > 0 && 
            csvTable[0].length >= 2 && 
            csvTable[0][0].toString().toLowerCase().contains('word')) {
          startIndex = 1;
        }

        for (int i = startIndex; i < csvTable.length; i++) {
          final row = csvTable[i];
          if (row.length >= 2) {
            final original = row[0].toString().trim();
            final translation = row[1].toString().trim();
            
            if (original.isNotEmpty && translation.isNotEmpty) {
              words.add(WordModel(
                id: uuid.v4(),
                original: original,
                translation: translation,
                langCode: 'en-US',
              ));
            }
          }
        }

        if (words.isEmpty) throw Exception("CSV faylidan so'zlar topilmadi.");

        importedSets.add(VocabSetModel(
          id: uuid.v4(),
          title: '',
          createdAt: DateTime.now(),
          words: words,
        ));

      } else {
        // --- JSON IMPORT LOGIC ---
        final dynamic decoded = jsonDecode(content);
        final Map<String, dynamic> data = decoded as Map<String, dynamic>;
        
        if (data['app'] != _appIdentifier) {
          throw Exception('Ushbu fayl Nayza Vocab’ga tegishli emas yoki formati noto\'g\'ri.');
        }

        final List<dynamic> setsJson = (data['sets'] as List<dynamic>?) ?? [];

        for (var sJson in setsJson) {
          final Map<String, dynamic> setMap = Map<String, dynamic>.from(sJson as Map<dynamic, dynamic>);
          final baseSet = VocabSetModel.fromMap(setMap);
          
          final freshSet = VocabSetModel(
            id: uuid.v4(),
            title: '${baseSet.title} $importedSuffix',
            createdAt: DateTime.now(),
            words: baseSet.words.map((w) => w.copyWith(id: uuid.v4())).toList(),
          );
          
          importedSets.add(freshSet);
        }
      }

      return importedSets;
    } catch (e) {
      debugPrint('DataService: Import Error: $e');
      rethrow; // Xatolik ekranga chiqishi uchun yuqoriga yuboramiz
    }
  }
}
