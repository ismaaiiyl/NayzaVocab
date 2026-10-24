import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nayza_vocab/core/models/app_update_info.dart';

class AppUpdateService {
  static const String repoOwner = 'ismaaiiyl';
  static const String repoName = 'NayzaVocab';
  static const String latestReleaseApi =
      'https://api.github.com/repos/$repoOwner/$repoName/releases/latest';

  final http.Client _client;

  AppUpdateService({http.Client? client}) : _client = client ?? http.Client();

  /// Eng oxirgi relizni GitHub API orqali tekshirish
  Future<AppUpdateInfo?> checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await _client.get(
        Uri.parse(latestReleaseApi),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      );

      if (response.statusCode != 200) {
        debugPrint('GitHub Release mavjud emas yoki xatolik: ${response.statusCode}');
        return null;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final tagName = data['tag_name'] as String? ?? '';
      final body = data['body'] as String? ?? '';
      final assets = data['assets'] as List<dynamic>? ?? [];

      String downloadUrl = '';
      String apkName = 'NayzaVocab-$tagName.apk';

      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        if (name.toLowerCase().endsWith('.apk')) {
          downloadUrl = asset['browser_download_url'] as String? ?? '';
          apkName = name;
          break;
        }
      }

      // Agar .apk biriktirilmagan bo'lsa, reliz sahifasi havolasi fallback bo'ladi
      if (downloadUrl.isEmpty) {
        downloadUrl = data['html_url'] as String? ?? '';
      }

      final hasUpdate = AppUpdateInfo.isNewerVersion(tagName, currentVersion);

      return AppUpdateInfo(
        latestVersion: tagName,
        currentVersion: currentVersion,
        hasUpdate: hasUpdate,
        releaseNotes: body,
        downloadUrl: downloadUrl,
        fileName: apkName,
      );
    } catch (e, stack) {
      debugPrint('Yangilanish tekshirishda xatolik: $e\n$stack');
      return null;
    }
  }

  /// APK faylni yuklab olish va Android tizimida o'rnatishni boshlash
  Future<bool> downloadAndInstallApk({
    required String downloadUrl,
    required String fileName,
    required void Function(double progress) onProgress,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final apkFile = File('${tempDir.path}/$fileName');

      if (await apkFile.exists()) {
        await apkFile.delete();
      }

      final request = http.Request('GET', Uri.parse(downloadUrl));
      final response = await _client.send(request);

      if (response.statusCode != 200) {
        debugPrint('APK yuklashda server xatoligi: ${response.statusCode}');
        return false;
      }

      final totalBytes = response.contentLength ?? 0;
      int downloadedBytes = 0;
      final fileSink = apkFile.openWrite();

      await for (final chunk in response.stream) {
        fileSink.add(chunk);
        downloadedBytes += chunk.length;
        if (totalBytes > 0) {
          onProgress(downloadedBytes / totalBytes);
        }
      }

      await fileSink.flush();
      await fileSink.close();

      onProgress(1.0);

      // Faqat Android qurilmada APK o'rnatuvchini ochamiz
      if (!kIsWeb && Platform.isAndroid) {
        final result = await OpenFilex.open(apkFile.path);
        debugPrint('APK ochish natijasi: ${result.message}');
        return result.type == ResultType.done;
      }

      return true;
    } catch (e, stack) {
      debugPrint('APK yuklab o\'rnatishda xatolik: $e\n$stack');
      return false;
    }
  }
}
