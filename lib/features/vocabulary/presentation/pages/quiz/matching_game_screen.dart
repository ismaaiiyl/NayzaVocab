import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/matching_item.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/quiz_models.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/matching_game_app_bar.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz/widgets/matching_grid.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  List<MatchingItem> _currentItems = [];
  int _stageIndex = 0;
  MatchingItem? _firstSelection;
  MatchingItem? _wrongSelection;
  MatchingItem? _secondWrongSelection;
  MatchingItem? _correctSelection;
  MatchingItem? _secondCorrectSelection;
  final AudioHelper _audioHelper = AudioHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepareStage());
  }

  void _prepareStage() {
    final allWords = context.read<QuizProvider>().trainingList;
    final int start = _stageIndex * 6;
    if (start >= allWords.length) {
      _showSummary();
      return;
    }

    final int end = (start + 6).clamp(0, allWords.length);
    final stageWords = allWords.sublist(start, end);
    final List<MatchingItem> items = [];
    for (final w in stageWords) {
      items.add(MatchingItem(text: w.original, pairId: w.id, isOriginal: true));
      items.add(MatchingItem(text: w.translation, pairId: w.id, isOriginal: false));
    }
    items.shuffle();
    if (mounted) {
      setState(() {
        _currentItems = items;
        _firstSelection = null;
      });
    }
  }

  Future<void> _handleTap(MatchingItem item) async {
    if (item.isMatched || _wrongSelection != null || _correctSelection != null) return;

    if (_firstSelection == item) {
      setState(() {
        item.isSelected = false;
        _firstSelection = null;
      });
      return;
    }

    if (_firstSelection != null && _firstSelection!.isOriginal == item.isOriginal) {
      setState(() {
        _firstSelection!.isSelected = false;
        item.isSelected = true;
        _firstSelection = item;
      });
      return;
    }

    if (_firstSelection == null) {
      setState(() {
        item.isSelected = true;
        _firstSelection = item;
      });
      return;
    }

    setState(() => item.isSelected = true);
    final first = _firstSelection!;
    final quiz = context.read<QuizProvider>();
    final word = quiz.trainingList.where((w) => w.id == first.pairId).firstOrNull;

    if (first.pairId == item.pairId) {
      await _onMatchSuccess(first, item, word);
    } else {
      await _onMatchFailure(first, item, word);
    }
  }

  Future<void> _onMatchSuccess(MatchingItem first, MatchingItem second, WordModel? word) async {
    _audioHelper.playSuccess();
    context.read<QuizProvider>().markCorrect();
    if (word != null) context.read<VocabSetProvider>().updateWordStats(word, isCorrect: true);
    setState(() {
      _correctSelection = first;
      _secondCorrectSelection = second;
    });
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;
    setState(() {
      first.isMatched = second.isMatched = true;
      first.isSelected = second.isSelected = false;
      _correctSelection = _secondCorrectSelection = _firstSelection = null;
    });
    if (_currentItems.every((it) => it.isMatched)) {
      Future<void>.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() => _stageIndex++);
        _prepareStage();
      });
    }
  }

  Future<void> _onMatchFailure(MatchingItem first, MatchingItem second, WordModel? word) async {
    _audioHelper.playError();
    if (word != null) {
      context.read<QuizProvider>().markIncorrect(word);
      context.read<VocabSetProvider>().updateWordStats(word, isCorrect: false);
    }
    setState(() {
      _wrongSelection = first;
      _secondWrongSelection = second;
    });
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) return;
    setState(() {
      first.isSelected = second.isSelected = false;
      _wrongSelection = _secondWrongSelection = _firstSelection = null;
    });
  }

  void _showSummary() {
    context.pushReplacementNamed('quiz-results', extra: {
      'mode': QuizMode.matching,
      'direction': QuizDirection.originalToTranslation,
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: MatchingGameAppBar(
        onToggleMute: () {
          settingsProvider.toggleMute();
          _audioHelper.isMuted = settingsProvider.isMuted;
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${l10n.findPairsLabel} (${l10n.stageLabel(_stageIndex + 1)})',
              style: const TextStyle(color: AppTheme.textDim, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: MatchingGrid(
                items: _currentItems,
                correctSelection: _correctSelection,
                secondCorrectSelection: _secondCorrectSelection,
                wrongSelection: _wrongSelection,
                secondWrongSelection: _secondWrongSelection,
                onTap: _handleTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioHelper.stopAll();
    super.dispose();
  }
}
