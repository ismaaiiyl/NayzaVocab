import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class LibraryShimmerCard extends StatelessWidget {
  const LibraryShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 110,
            decoration: BoxDecoration(
              color: AppTheme.darkNavy,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 40, height: 14, color: AppTheme.darkNavy),
                const SizedBox(height: 12),
                Container(width: 150, height: 20, color: AppTheme.darkNavy),
                const SizedBox(height: 8),
                Container(width: 200, height: 14, color: AppTheme.darkNavy),
                const SizedBox(height: 4),
                Container(width: 180, height: 14, color: AppTheme.darkNavy),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
