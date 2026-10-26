import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';

class SetWordTile extends StatelessWidget {
  final WordModel word;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const SetWordTile({
    super.key,
    required this.word,
    required this.onTap,
    required this.onDelete,
  });

  Widget _buildStatusIndicator() {
    if (word.isLearned) {
      return Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: AppTheme.success,
          shape: BoxShape.circle,
        ),
      );
    }
    if (word.isDifficult || word.wrongAttempts > 0) {
      return Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: AppTheme.error,
          shape: BoxShape.circle,
        ),
      );
    }
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(
        color: AppTheme.borderNavy,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceNavy,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.borderNavy, width: 1),
            ),
            child: Row(
              children: [
                _buildStatusIndicator(),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.original,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        word.translation,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textDim,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 18, color: AppTheme.error),
                  onPressed: onDelete,
                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
