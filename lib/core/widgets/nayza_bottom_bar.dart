import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_icon.dart';

class NayzaBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onCentralTap;

  const NayzaBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onCentralTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceNavy.withValues(alpha: 0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(
          color: AppTheme.borderNavy,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 50, // Even more compact for better aesthetics
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Navigation Items Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _BottomNavItem(
                    icon: LucideIcons.home,
                    isActive: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                  _BottomNavItem(
                    icon: LucideIcons.library,
                    isActive: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                  const SizedBox(width: 60), // Precise gap for trident
                  _BottomNavItem(
                    icon: LucideIcons.flame,
                    isActive: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                  _BottomNavItem(
                    icon: LucideIcons.settings,
                    isActive: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ],
              ),
              // Popping Central Trident Button - Lowered position
              Positioned(
                top: -10, 
                child: _buildCentralButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCentralButton(BuildContext context) {
    return GestureDetector(
      onTap: onCentralTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.electricGold, Color(0xFFFFD700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.surfaceNavy, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppTheme.electricGold.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: NayzaIcon(
            color: AppTheme.surfaceNavy,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppTheme.electricGold : AppTheme.textDim,
              size: 24,
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 4,
              width: isActive ? 4 : 0,
              decoration: const BoxDecoration(
                color: AppTheme.electricGold,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
