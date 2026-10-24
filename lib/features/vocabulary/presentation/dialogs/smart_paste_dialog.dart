import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';

class SmartPasteDialog extends StatefulWidget {
  const SmartPasteDialog({super.key});

  static Future<List<MapEntry<String, String>>> show(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => const SmartPasteDialog(),
    );

    if (result == null || result.trim().isEmpty) return [];

    return _parseText(result);
  }

  static List<MapEntry<String, String>> _parseText(String text) {
    final lines = text.split('\n');
    final pairs = <MapEntry<String, String>>[];
    final separators = [
      ' - ', ' – ', ' — ', ' = ', ' : ',
      '-', '–', '—', '=', ':', ';',
    ];

    for (final line in lines) {
      final cleanLine = line.trim();
      if (cleanLine.isEmpty) continue;

      String? original;
      String? translation;

      for (final sep in separators) {
        if (cleanLine.contains(sep)) {
          final parts = cleanLine.split(sep);
          if (parts.length >= 2) {
            original = parts.first.trim();
            translation = parts.sublist(1).join(sep).trim();
            break;
          }
        }
      }

      if (original != null &&
          translation != null &&
          original.isNotEmpty &&
          translation.isNotEmpty) {
        pairs.add(MapEntry(original, translation));
      }
    }

    return pairs;
  }

  @override
  State<SmartPasteDialog> createState() => _SmartPasteDialogState();
}

class _SmartPasteDialogState extends State<SmartPasteDialog> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.borderNavy),
      ),
      title: Text(
        l10n.smartPasteTitle,
        style: const TextStyle(color: AppTheme.electricGold, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: TextField(
          controller: _textController,
          maxLines: 10,
          style: const TextStyle(color: AppTheme.textMain),
          decoration: InputDecoration(
            hintText: l10n.smartPasteHint,
            hintStyle: const TextStyle(color: AppTheme.textDim),
            filled: true,
            fillColor: AppTheme.surfaceNavy.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderNavy),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.borderNavy),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.electricGold),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.electricGold,
            foregroundColor: AppTheme.surfaceNavy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.pop(context, _textController.text),
          child: Text(l10n.addWord),
        ),
      ],
    );
  }
}
