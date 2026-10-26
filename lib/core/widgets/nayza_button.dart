import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class NayzaButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final bool isFullWidth;
  final double? height;
  final double? fontSize;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  const NayzaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.isFullWidth = true,
    this.height,
    this.fontSize,
    this.iconSize,
    this.padding,
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
    final double buttonHeight = widget.height ?? 54.0;
    final double iconSz = widget.iconSize ?? 18.0;
    final double fontSz = widget.fontSize ?? 14.0;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          height: buttonHeight,
          padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color ?? AppTheme.electricGold,
                (widget.color ?? AppTheme.electricGold).withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (widget.color ?? AppTheme.electricGold).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: AppTheme.surfaceNavy,
                  size: iconSz,
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Text(
                    widget.text.toUpperCase(),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.surfaceNavy,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSz,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
