import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/quiz_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MatchingItem {
  final String text;
  final String pairId;
  final bool isOriginal;
  bool isMatched;
  bool isSelected;

  MatchingItem({
    required this.text,
    required this.pairId,
    required this.isOriginal,
    this.isMatched = false,
    this.isSelected = false,
  });
}

class MatchingGameScreen extends StatefulWidget {
  const MatchingGameScreen({super.key});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  List<MatchingItem> _currentItems = [];
  int _stageIndex = 0;
  MatchingItem? _firstSelection;
  final AudioHelper _audioHelper = AudioHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prepareStage());
  }

  void _prepareStage() {
    final quizProvider = context.read<QuizProvider>();
    final allWords = quizProvider.trainingList;
    
    // Split into chunks of 6 words (12 items)
    final int start = _stageIndex * 6;
    if (start >= allWords.length) {
      _showSummary();
      return;
    }
    
    final int end = (start + 6).clamp(0, allWords.length);
    final stageWords = allWords.sublist(start, end);

    final List<MatchingItem> items = [];
    for (var w in stageWords) {
      items.add(MatchingItem(text: w.original, pairId: w.id, isOriginal: true));
      items.add(MatchingItem(text: w.translation, pairId: w.id, isOriginal: false));
    }

    items.shuffle();
    setState(() {
      _currentItems = items;
      _firstSelection = null;
    });
  }

  MatchingItem? _wrongSelection;
  MatchingItem? _secondWrongSelection;
  MatchingItem? _correctSelection;
  MatchingItem? _secondCorrectSelection;

  void _handleTap(MatchingItem item) async {
    if (item.isMatched || item.isSelected || _wrongSelection != null || _correctSelection != null) return;

    setState(() => item.isSelected = true);

    if (_firstSelection == null) {
      _firstSelection = item;
    } else {
      final quizProvider = context.read<QuizProvider>();
      
      // Senior safety: Use try/catch to gracefully handle stale pair IDs
      // instead of firstWhere which throws StateError on no match.
      final WordModel word1;
      try {
        word1 = quizProvider.trainingList.firstWhere((w) => w.id == _firstSelection!.pairId);
      } catch (_) {
        // Pair not found — reset selection gracefully
        setState(() {
          _firstSelection!.isSelected = false;
          _firstSelection = null;
        });
        return;
      }

      // Check for match
      if (_firstSelection!.pairId == item.pairId && _firstSelection!.isOriginal != item.isOriginal) {
        // MATCH!
        _audioHelper.playSuccess();
        quizProvider.markCorrect();
        context.read<VocabSetProvider>().updateWordStats(_firstSelection!.pairId, isCorrect: true);
        
        setState(() {
          _correctSelection = _firstSelection;
          _secondCorrectSelection = item;
        });

        await Future<void>.delayed(const Duration(milliseconds: 500));

        setState(() {
          _correctSelection!.isMatched = true;
          _secondCorrectSelection!.isMatched = true;
          _correctSelection!.isSelected = false;
          _secondCorrectSelection!.isSelected = false;
          _correctSelection = null;
          _secondCorrectSelection = null;
          _firstSelection = null;
        });

        if (_currentItems.every((it) => it.isMatched)) {
          Future<void>.delayed(const Duration(milliseconds: 600), () {
             setState(() => _stageIndex++);
             _prepareStage();
          });
        }
      } else {
        // WRONG
        _audioHelper.playError();
        quizProvider.markIncorrect(word1);
        context.read<VocabSetProvider>().updateWordStats(word1.id, isCorrect: false);

        setState(() {
          _wrongSelection = _firstSelection;
          _secondWrongSelection = item;
        });

        await Future<void>.delayed(const Duration(milliseconds: 600));

        setState(() {
          _wrongSelection!.isSelected = false;
          _secondWrongSelection!.isSelected = false;
          _wrongSelection = null;
          _secondWrongSelection = null;
          _firstSelection = null;
        });
      }
    }
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
      appBar: AppBar(
        title: Text(l10n.matchingGameTitle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              settingsProvider.toggleMute();
              _audioHelper.isMuted = settingsProvider.isMuted;
            },
            icon: Icon(
              settingsProvider.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
              color: settingsProvider.isMuted ? Colors.redAccent : AppTheme.electricGold,
            ),
          ),
          const SizedBox(width: 8),
        ],
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _currentItems.length,
                itemBuilder: (context, index) {
                  final item = _currentItems[index];
                  return _buildTile(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(MatchingItem item) {
    final bool isSelected = item.isSelected;
    final bool isMatched = item.isMatched;
    final bool isCorrect = (item == _correctSelection || item == _secondCorrectSelection);
    final bool isWrong = (item == _wrongSelection || item == _secondWrongSelection);

    return AnimatedScale(
      scale: isMatched ? 0.0 : (isSelected ? 1.05 : 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isMatched ? 0.0 : 1.0,
        child: GestureDetector(
          onTap: isMatched ? null : () => _handleTap(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isCorrect
                  ? Colors.greenAccent.withValues(alpha: 0.2)
                  : isWrong
                      ? Colors.redAccent.withValues(alpha: 0.2)
                      : (isSelected ? AppTheme.electricGold.withValues(alpha: 0.15) : AppTheme.surfaceNavy),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCorrect
                    ? Colors.greenAccent
                    : isWrong
                        ? Colors.redAccent
                        : (isSelected ? AppTheme.electricGold : AppTheme.borderNavy),
                width: isSelected ? 3 : 1.5,
              ),
              boxShadow: isSelected && !isMatched
                  ? [
                      BoxShadow(
                        color: (isCorrect ? Colors.greenAccent : (isWrong ? Colors.redAccent : AppTheme.electricGold))
                            .withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  item.text,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isCorrect
                        ? Colors.greenAccent
                        : isWrong
                            ? Colors.redAccent
                            : (isSelected ? AppTheme.electricGold : AppTheme.textMain),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
