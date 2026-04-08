import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final PageController _pageController;
  late final VocabSetProvider _provider;
  final _answerController = TextEditingController();
  final AudioHelper _audioHelper = AudioHelper();

  // To keep track of missed words within this session
  final Set<WordModel> _missedWords = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _provider = Provider.of<VocabSetProvider>(context, listen: false);
    _audioHelper.preloadSounds();
  }

  void _checkAnswer(WordModel currentWord, String answer) {
    final isCorrect = answer.trim().toLowerCase() == currentWord.translation.toLowerCase();
    
    _audioHelper.playSound(isCorrect);

    if (isCorrect) {
      _goToNextPage();
    } else {
      _missedWords.add(currentWord);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong! Try again.'), duration: Duration(seconds: 1), backgroundColor: Colors.redAccent),
      );
    }
    _answerController.clear();
  }
  
  void _goToNextPage(){
       if (_pageController.page!.toInt() < _provider.trainingList.length - 1) {
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        _showSummary();
      }
  }

  void _showSummary() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Session Complete!'),
        content: _missedWords.isEmpty
            ? const Text('Congratulations! You got everything right!')
            : Text('You missed ${_missedWords.length} out of ${_provider.trainingList.length} words.'),
        actions: [
          if (_missedWords.isNotEmpty)
            TextButton(
              onPressed: () {
                // Logic to retry missed words
                final missed = List<WordModel>.from(_missedWords);
                _missedWords.clear();
                setState(() {
                  _provider.trainingList.clear();
                  _provider.trainingList.addAll(missed);
                  _provider.trainingList.shuffle();
                });
                Navigator.pop(context);
                _pageController.jumpToPage(0);
              },
              child: const Text('Retry Missed Words'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to selection/history
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Consumer<VocabSetProvider>(
        builder: (context, provider, child) {
          if (provider.trainingList.isEmpty) {
            return const Center(child: Text('Something went wrong. No words for the quiz.'));
          }
          return PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swiping
            itemCount: provider.trainingList.length,
            itemBuilder: (context, index) {
              final word = provider.trainingList[index];
              return _buildQuizCard(word);
            },
          );
        },
      ),
    );
  }

  Widget _buildQuizCard(WordModel word) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word.original, // Show the original word
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
           IconButton(
            icon: const Icon(Icons.volume_up, size: 30),
            onPressed: () => _audioHelper.pronounce(word.original),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: _answerController,
            decoration: const InputDecoration(hintText: 'Enter the translation...'), // Ask for translation
            textAlign: TextAlign.center,
            onSubmitted: (value) => _checkAnswer(word, value),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () => _checkAnswer(word, _answerController.text), child: const Text('Check'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _answerController.dispose();
    _audioHelper.dispose();
    super.dispose();
  }
}
