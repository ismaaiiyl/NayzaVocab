// ignore_for_file: avoid_print
import 'dart:io';
import 'package:uuid/uuid.dart';

void main() async {
  final file = File('mabdaul-qiroat.txt');
  if (!await file.exists()) {
    print('File not found: mabdaul-qiroat.txt');
    return;
  }

  final lines = await file.readAsLines();
  const uuid = Uuid();

  final bookId = uuid.v4();
  const bookTitle = 'Mabdaul Qiroat';
  const bookDescription = 'Boshlang\'\'ich arab tili darsligi';
  const bookCoverUrl = ''; // Hozircha bo'sh
  const bookTargetLang = 'ar'; // O'rganilayotgan til (Arabic)
  const bookBaseLang = 'uz';   // Tarjima tili (Uzbek)

  final sqlBuffer = StringBuffer();

  // 1. Insert Book
  sqlBuffer.writeln('-- Insert Book');
  sqlBuffer.writeln(
    'INSERT INTO books (id, title, description, cover_url, target_lang, base_lang, created_at) '
    'VALUES (\'$bookId\', \'$bookTitle\', \'$bookDescription\', \'$bookCoverUrl\', \'$bookTargetLang\', \'$bookBaseLang\', NOW());'
  );
  sqlBuffer.writeln();

  String? currentUnitId;
  int unitIndex = 0;

  for (var line in lines) {
    line = line.trim();
    if (line.isEmpty) continue;

    // Check for unit marker: "X-dars" or "**X-dars**"
    final unitMatch = RegExp(r'^(\*\*)?(\d+)-dars(\*\*)?').firstMatch(line);
    if (unitMatch != null) {
      final unitTitle = line.replaceAll('*', '');
      currentUnitId = uuid.v4();
      unitIndex++;
      
      sqlBuffer.writeln('-- Unit $unitIndex: $unitTitle');
      sqlBuffer.writeln(
        'INSERT INTO units (id, book_id, title, index) '
        'VALUES (\'$currentUnitId\', \'$bookId\', \'$unitTitle\', $unitIndex);'
      );
      continue;
    }

    // It's a word line: "Original - Translation"
    if (currentUnitId != null && line.contains(' - ')) {
      final parts = line.split(' - ');
      if (parts.length >= 2) {
        final original = parts[0].trim().replaceAll("'", "''");
        final translation = parts.sublist(1).join(' - ').trim().replaceAll("'", "''");
        final wordId = uuid.v4();

        sqlBuffer.writeln(
          'INSERT INTO words (id, unit_id, original, translation) '
          'VALUES (\'$wordId\', \'$currentUnitId\', \'$original\', \'$translation\');'
        );
      }
    }
  }

  final outputFile = File('mabdaul-qiroat.sql');
  await outputFile.writeAsString(sqlBuffer.toString());
  print('Successfully generated mabdaul-qiroat.sql');
}
