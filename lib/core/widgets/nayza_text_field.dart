import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';

class NayzaTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool isRtl;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const NayzaTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.isRtl = false,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.focusNode,
    this.keyboardType,
  });

  @override
  State<NayzaTextField> createState() => _NayzaTextFieldState();
}

class _NayzaTextFieldState extends State<NayzaTextField> {
  late FocusNode _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _initFocusNode();
  }

  void _initFocusNode() {
    _internalFocusNode = widget.focusNode ?? FocusNode();
    _internalFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(NayzaTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _internalFocusNode.removeListener(_onFocusChange);
      if (oldWidget.focusNode == null) {
        _internalFocusNode.dispose();
      }
      _initFocusNode();
    }
  }

  @override
  void dispose() {
    _internalFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _internalFocusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: AppTheme.electricGold.withValues(alpha: 0.15),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _internalFocusNode,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        textDirection: widget.isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: const TextStyle(color: AppTheme.textMain),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isFocused ? AppTheme.electricGold : AppTheme.borderNavy,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.borderNavy, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.electricGold, width: 2),
          ),
        ),
      ),
    );
  }
}
