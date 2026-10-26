import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
      debugPrint('[OTA-UPDATE] Tekshirish boshlandi: joriy versiya=$currentVersion, API=$latestReleaseApi');

      final response = await _client.get(
        Uri.parse(latestReleaseApi),
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'NayzaVocab-App',
        },
      );

      debugPrint('[OTA-UPDATE] GitHub API javob kodi: ${response.statusCode}');
      if (response.statusCode != 200) {
        debugPrint('[OTA-UPDATE] GitHub Release xatoligi: ${response.statusCode}');
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

      if (downloadUrl.isEmpty) {
        downloadUrl = data['html_url'] as String? ?? '';
      }

      final hasUpdate = AppUpdateInfo.isNewerVersion(tagName, currentVersion);
      debugPrint('[OTA-UPDATE] Reliz: tag=$tagName, hasUpdate=$hasUpdate, apk=$apkName, url=$downloadUrl');

      return AppUpdateInfo(
        latestVersion: tagName,
        currentVersion: currentVersion,
        hasUpdate: hasUpdate,
        releaseNotes: body,
        downloadUrl: downloadUrl,
        fileName: apkName,
      );
    } catch (e, stack) {
      debugPrint('[OTA-UPDATE] Yangilanish tekshirishda xatolik: $e\n$stack');
      return null;
    }
  }

  /// Brauzer orqali to'g'ridan-to'g'ri yuklab olish
  Future<void> openInBrowser(String url) async {
    try {
      debugPrint('[OTA-UPDATE] Brauzerda ochilmoqda: $url');
      final uri = Uri.parse(url);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e, stack) {
      debugPrint('[OTA-UPDATE] Brauzerda ochishda xatolik: $e\n$stack');
    }
  }

  /// APK faylni yuklab olish va Android tizimida o'rnatishni boshlash
  Future<bool> downloadAndInstallApk({
    required String downloadUrl,
    required String fileName,
    required void Function(double progress, String progressText) onProgress,
  }) async {
    try {
      Directory? targetDir;
      if (!kIsWeb && Platform.isAndroid) {
        final extDirs = await getExternalCacheDirectories();
        if (extDirs != null && extDirs.isNotEmpty) targetDir = extDirs.first;
      }
      targetDir ??= await getTemporaryDirectory();
      final apkFile = File('${targetDir.path}/$fileName');
      debugPrint('[OTA-UPDATE] Yuklab olish boshlanmoqda: $downloadUrl');
      debugPrint('[OTA-UPDATE] Saqlash joyi: ${apkFile.path}');

      if (await apkFile.exists()) {
        try { await apkFile.delete(); } catch (_) {}
      }

      final request = http.Request('GET', Uri.parse(downloadUrl));
      request.headers['User-Agent'] = 'NayzaVocab-App';
      final response = await _client.send(request);

      debugPrint('[OTA-UPDATE] Server javob kodi: ${response.statusCode}, hajmi: ${response.contentLength} bayt');
      if (response.statusCode != 200) {
        debugPrint('[OTA-UPDATE] Server xatoligi: ${response.statusCode}');
        return false;
      }

      final totalBytes = response.contentLength ?? 0;
      int downloadedBytes = 0;
      int lastReportedPercent = -1;
      final fileSink = apkFile.openWrite();

      await for (final chunk in response.stream) {
        fileSink.add(chunk);
        downloadedBytes += chunk.length;
        if (totalBytes > 0) {
          final percent = ((downloadedBytes / totalBytes) * 100).toInt();
          if (percent > lastReportedPercent) {
            lastReportedPercent = percent;
            final dMb = (downloadedBytes / (1024 * 1024)).toStringAsFixed(1);
            final tMb = (totalBytes / (1024 * 1024)).toStringAsFixed(1);
            onProgress(downloadedBytes / totalBytes, '$dMb MB / $tMb MB ($percent%)');
            if (percent % 20 == 0 || percent == 100) {
              debugPrint('[OTA-UPDATE] Yuklanish: $percent% ($dMb MB / $tMb MB)');
            }
          }
        } else {
          final dMb = (downloadedBytes / (1024 * 1024)).toStringAsFixed(1);
          onProgress(0.0, '$dMb MB');
        }
      }

      await fileSink.flush();
      await fileSink.close();

      final actualSize = await apkFile.length();
      debugPrint('[OTA-UPDATE] Fayl diskka to\'liq saqlandi: $actualSize bayt (${(actualSize / (1024 * 1024)).toStringAsFixed(1)} MB)');
      onProgress(1.0, '100%');

      if (!kIsWeb && Platform.isAndroid) {
        bool installed = false;
        try {
          debugPrint('[OTA-UPDATE] Native installer chaqirilmoqda...');
          const channel = MethodChannel('uz.nayza.vocab/installer');
          final success = await channel.invokeMethod<bool>('installApk', {'filePath': apkFile.path});
          installed = success ?? false;
          debugPrint('[OTA-UPDATE] Native installer natijasi: $installed');
        } catch (e) {
          debugPrint('[OTA-UPDATE] Native installer xatosi: $e, OpenFilex sinab ko\'riladi');
          try {
            final result = await OpenFilex.open(apkFile.path, type: 'application/vnd.android.package-archive');
            installed = result.type == ResultType.done;
            debugPrint('[OTA-UPDATE] OpenFilex natijasi: ${result.message} (${result.type})');
          } catch (e2) {
            debugPrint('[OTA-UPDATE] OpenFilex xatosi: $e2');
          }
        }
        if (!installed) {
          debugPrint('[OTA-UPDATE] Tizim o\'rnatuvchisi ochilmadi, brauzerga o\'tkaziladi');
          await openInBrowser(downloadUrl);
        }
      }
      return true;
    } catch (e, stack) {
      debugPrint('[OTA-UPDATE] Xatolik yuz berdi: $e\n$stack');
      return false;
    }
  }
}
