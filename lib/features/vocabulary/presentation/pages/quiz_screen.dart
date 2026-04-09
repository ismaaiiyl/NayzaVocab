import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/core/widgets/nayza_widgets.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:flutter/services.dart';

enum QuizMode { choice, input }

class QuizScreen extends StatefulWidget {
  final QuizMode quizMode;
  const QuizScreen({super.key, required this.quizMode});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _answerController = TextEditingController();
  final AudioHelper _audioHelper = AudioHelper();
  
  int _currentIndex = 0;
  bool _isAnswered = false;
  late QuizMode _quizMode;
  List<String> _options = [];
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _quizMode = widget.quizMode;
    
    // Sync audio state with provider on start
    final provider = context.read<VocabSetProvider>();
    _audioHelper.isMuted = provider.isMuted;

    WidgetsBinding.instance.addPostFrameCallback((_) {
       _prepareQuestion();
    });
  }

  void _prepareQuestion() {
    final provider = context.read<VocabSetProvider>();
    if (provider.trainingList.isEmpty) return;
    
    _selectedAnswer = null; // Reset
    final currentWord = provider.trainingList[_currentIndex];
    
    // Generate multiple choice options for Choice Mode
    _generateOptions(currentWord);
    setState(() {});
  }

  void _generateOptions(currentWord) {
    final provider = context.read<VocabSetProvider>();
    final trainingWords = provider.trainingList;
    
    // Normalize correct answer
    final String correctTranslation = currentWord.translation.trim();
    final String correctLower = correctTranslation.toLowerCase();

    // 1. Collect unique translations from current training session
    final Set<String> uniqueTranslations = {correctTranslation};
    final Set<String> normalizedSet = {correctLower};

    // Helper to add unique translations safely
    void addUnique(String t) {
      final trimmed = t.trim();
      final lowered = trimmed.toLowerCase();
      if (!normalizedSet.contains(lowered)) {
        uniqueTranslations.add(trimmed);
        normalizedSet.add(lowered);
      }
    }

    // Attempt to fill from local training pool first
    final localPool = trainingWords.map((w) => w.translation).toList()..shuffle();
    for (var t in localPool) {
      if (uniqueTranslations.length >= 4) break;
      addUnique(t);
    }

    // 2. If still less than 4, pull from Global Pool across all sets
    if (uniqueTranslations.length < 4) {
      final globalPool = provider.getAllTranslations()..shuffle();
      for (var t in globalPool) {
        if (uniqueTranslations.length >= 4) break;
        addUnique(t);
      }
    }

    _options = uniqueTranslations.toList()..shuffle();
  }

  void _handleAnswer(String answer) {
    if (_isAnswered) return;
    
    final provider = context.read<VocabSetProvider>();
    final currentWord = provider.trainingList[_currentIndex];
    
    final correct = answer.trim().toLowerCase() == currentWord.translation.toLowerCase();
    
    setState(() {
      _isAnswered = true;
      _selectedAnswer = answer;
    });

    if (correct) {
      provider.markCorrect(currentWord);
      _audioHelper.playSuccess();
    } else {
      provider.markIncorrect(currentWord);
      _audioHelper.playError();
      HapticFeedback.heavyImpact(); // Vibrate on error
    }

    // Auto-advance after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    final provider = context.read<VocabSetProvider>();
    if (_currentIndex < provider.trainingList.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _answerController.clear();
        _prepareQuestion();
      });
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _showSummary();
    }
  }

  void _showSummary() {
    final provider = context.read<VocabSetProvider>();
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: AppTheme.surfaceNavy,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.trophy, size: 64, color: AppTheme.electricGold),
            const SizedBox(height: 16),
            Text('TEST YAKUNLANDI!', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('TO\'G\'RI', provider.correctCount.toString(), Colors.greenAccent),
                _buildStatItem('XATO', provider.incorrectCount.toString(), Colors.redAccent),
              ],
            ),
            const SizedBox(height: 32),
            if (provider.failedQueue.isNotEmpty)
              NayzaButton(
                text: 'XATOLARNI TAKRORLASH',
                icon: LucideIcons.refreshCcw,
                onPressed: () {
                  provider.retryFailedWords();
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 0;
                    _isAnswered = false;
                    _prepareQuestion();
                  });
                  _pageController.jumpToPage(0);
                },
              ),
            const SizedBox(height: 12),
            NayzaButton(
              text: 'YAKUNLASH',
              icon: LucideIcons.check,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: AppTheme.textDim, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VocabSetProvider>();
    final trainingList = provider.trainingList;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentIndex + 1} / ${trainingList.length}'),
        leading: IconButton(
          icon: const Icon(LucideIcons.x),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
              color: AppTheme.electricGold,
            ),
            onPressed: () {
              provider.toggleMute();
              AudioHelper().isMuted = provider.isMuted;
              AudioHelper().playToggle(provider.isMuted);
            },
          ),
        ],
      ),
      body: trainingList.isEmpty
          ? const Center(child: Text('Ma\'lumot yo\'q'))
          : PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trainingList.length,
              itemBuilder: (context, index) {
                final word = trainingList[index];
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: trainingList.isEmpty ? 0 : (_currentIndex + 1) / trainingList.length,
                        backgroundColor: const Color(0xFF1E2D4A),
                        color: AppTheme.electricGold,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const Spacer(),
                      Text(
                        word.original,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      IconButton(
                        onPressed: () => _audioHelper.speak(word.original, langCode: word.langCode ?? 'en-US'),
                        icon: const Icon(LucideIcons.volume2, color: AppTheme.electricGold, size: 32),
                      ),
                      const SizedBox(height: 48),
                      // Dual Mode Switcher
                      _buildResponseArea(word, index),
                      const Spacer(),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildResponseArea(word, index) {
     if (_quizMode == QuizMode.choice && _options.length >= 2) {
        // Choice Mode
        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: _options.map((opt) {
            Color cardColor = AppTheme.surfaceNavy;
            Color borderColor = const Color(0xFF233554);
            
            if (_isAnswered) {
              if (opt == word.translation) {
                cardColor = Colors.greenAccent.withValues(alpha: 0.4);
                borderColor = Colors.greenAccent;
              } else if (opt == _selectedAnswer) {
                cardColor = Colors.redAccent.withValues(alpha: 0.3);
                borderColor = Colors.redAccent;
              }
            }
            
            return InkWell(
              onTap: () => _handleAnswer(opt),
              child: Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: borderColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    opt,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      } else {
        // Input Mode
        return Column(
          children: [
            NayzaTextField(
              controller: _answerController,
              label: 'Tarjimani kiriting',
              hint: 'Javobingiz...',
              onSubmitted: (v) => _handleAnswer(v),
            ),
            const SizedBox(height: 24),
            NayzaButton(
              text: 'TEKSHIRISH',
              onPressed: () => _handleAnswer(_answerController.text),
            ),
          ],
        );
      }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _answerController.dispose();
    _audioHelper.dispose();
    super.dispose();
  }
}
