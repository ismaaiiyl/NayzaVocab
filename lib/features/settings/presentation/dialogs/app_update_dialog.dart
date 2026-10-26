import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/models/app_update_info.dart';
import 'package:nayza_vocab/core/services/app_update_service.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_button.dart';
import 'package:nayza_vocab/core/widgets/nayza_progress_bar.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/widgets/update_dialog_header.dart';
import 'package:nayza_vocab/features/settings/presentation/dialogs/widgets/update_release_notes_card.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class AppUpdateDialog extends StatefulWidget {
  final AppUpdateInfo updateInfo;
  final AppUpdateService? updateService;

  const AppUpdateDialog({
    super.key,
    required this.updateInfo,
    this.updateService,
  });

  static Future<void> show(BuildContext context, AppUpdateInfo info) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppUpdateDialog(updateInfo: info),
    );
  }

  @override
  State<AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {
  late final AppUpdateService _service;
  bool _isDownloading = false;
  double _progress = 0.0;
  String _progressText = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = widget.updateService ?? AppUpdateService();
  }

  Future<void> _startDownload() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
      _progressText = '0%';
      _errorMessage = null;
    });

    final success = await _service.downloadAndInstallApk(
      downloadUrl: widget.updateInfo.downloadUrl,
      fileName: widget.updateInfo.fileName,
      onProgress: (p, text) {
        if (mounted) {
          setState(() {
            _progress = p;
            _progressText = text;
          });
        }
      },
    );

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isDownloading = false;
        _errorMessage = AppLocalizations.of(context)!.updateCheckFailed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.surfaceNavy,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.electricGold.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UpdateDialogHeader(
              currentVersion: widget.updateInfo.currentVersion,
              latestVersion: widget.updateInfo.latestVersion,
            ),
            const SizedBox(height: 16),
            UpdateReleaseNotesCard(releaseNotes: widget.updateInfo.releaseNotes),
            const SizedBox(height: 16),
            if (_isDownloading) ...[
              NayzaProgressBar(
                current: (_progress * 100).toInt(),
                total: 100,
              ),
              const SizedBox(height: 8),
              Text(
                _progressText.isNotEmpty ? _progressText : l10n.downloadingUpdate,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.textDim, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => _service.openInBrowser(widget.updateInfo.downloadUrl),
                  child: Text(
                    l10n.openInBrowser,
                    style: const TextStyle(color: AppTheme.electricGold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppTheme.error, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton.icon(
                  onPressed: () => _service.openInBrowser(widget.updateInfo.downloadUrl),
                  icon: const Icon(Icons.open_in_browser, color: AppTheme.electricGold, size: 18),
                  label: Text(
                    l10n.openInBrowser,
                    style: const TextStyle(color: AppTheme.electricGold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (!_isDownloading) _buildActions(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: NayzaButton(
            text: l10n.updateNow,
            onPressed: _startDownload,
          ),
        ),
      ],
    );
  }
}
