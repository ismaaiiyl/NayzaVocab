import 'package:equatable/equatable.dart';

/// GitHub Release ma'lumotlarini saqlovchi model
class AppUpdateInfo extends Equatable {
  final String latestVersion;
  final String currentVersion;
  final bool hasUpdate;
  final String releaseNotes;
  final String downloadUrl;
  final String fileName;

  const AppUpdateInfo({
    required this.latestVersion,
    required this.currentVersion,
    required this.hasUpdate,
    required this.releaseNotes,
    required this.downloadUrl,
    required this.fileName,
  });

  /// Ikki versiyani solishtirish (masalan, '1.0.2' > '1.0.1')
  static bool isNewerVersion(String remote, String local) {
    final cleanRemote = _cleanVersion(remote);
    final cleanLocal = _cleanVersion(local);

    final remoteParts = cleanRemote.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final localParts = cleanLocal.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    final maxLength = remoteParts.length > localParts.length ? remoteParts.length : localParts.length;

    for (int i = 0; i < maxLength; i++) {
      final r = i < remoteParts.length ? remoteParts[i] : 0;
      final l = i < localParts.length ? localParts[i] : 0;
      if (r > l) return true;
      if (r < l) return false;
    }
    return false;
  }

  static String _cleanVersion(String v) {
    var s = v.trim().toLowerCase();
    if (s.startsWith('v')) {
      s = s.substring(1);
    }
    // Agar build number bo'lsa (1.0.1+2) faqat asosiy qismini olamiz
    if (s.contains('+')) {
      s = s.split('+').first;
    }
    return s;
  }

  @override
  List<Object?> get props => [
        latestVersion,
        currentVersion,
        hasUpdate,
        releaseNotes,
        downloadUrl,
        fileName,
      ];
}
