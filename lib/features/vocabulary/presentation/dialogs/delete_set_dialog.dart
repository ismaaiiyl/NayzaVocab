import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class DeleteSetDialog extends StatelessWidget {
  final VocabSetModel set;

  const DeleteSetDialog({super.key, required this.set});

  static Future<bool?> show(BuildContext context, VocabSetModel set) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteSetDialog(set: set),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppTheme.surfaceNavy,
      title: Text(l10n.deleteSetTitle, style: const TextStyle(color: AppTheme.error)),
      content: Text(l10n.deleteSetConfirmation(set.title)),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: Text(l10n.cancel, style: const TextStyle(color: AppTheme.textDim)),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<VocabSetProvider>().deleteVocabSet(set.id);
            context.pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.error,
            foregroundColor: Colors.white,
          ),
          child: Text(l10n.delete.toUpperCase()),
        ),
      ],
    );
  }
}
