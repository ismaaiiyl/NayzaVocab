import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class NayzaButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final bool isFullWidth;

  const NayzaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.isFullWidth = true,
  });

  @override
  State<NayzaButton> createState() => _NayzaButtonState();
}

class _NayzaButtonState extends State<NayzaButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          padding: widget.isFullWidth ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 24),
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color ?? AppTheme.electricGold,
                (widget.color ?? AppTheme.electricGold).withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? AppTheme.electricGold).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: AppTheme.surfaceNavy, size: 24),
                const SizedBox(width: 12),
              ],
              Text(
                widget.text.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.surfaceNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
