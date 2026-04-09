import 'dart:io';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'export_helper.dart';

class MobileExportHelper implements ExportHelper {
  @override
  Future<void> downloadJson(String jsonString, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsString(jsonString);

    try {
      // Use the instance method to avoid deprecation warnings in newer share_plus versions
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Nayza Vocab Backup',
        text: 'Mening Nayza Vocab to\'plamlarim zaxira nusxasi.',
      );
    } catch (e) {
      debugPrint("🔊 [MobileExport] Share Error: $e");
    }
  }
}

ExportHelper getExportHelper() => MobileExportHelper();
