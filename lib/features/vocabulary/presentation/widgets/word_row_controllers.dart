import 'package:flutter/material.dart';

class WordRowControllers {
  final TextEditingController original = TextEditingController();
  final TextEditingController translation = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void dispose() {
    original.dispose();
    translation.dispose();
    focusNode.dispose();
  }
}
