import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/utils/audio_helper.dart';
import 'package:nayza_vocab/features/vocabulary/domain/entities/word_entity.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocabulary_provider.dart';
import 'package:provider/provider.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  late final PageController _pageController;
  late final VocabularyProvider _provider;
  final _answerController = TextEditingController();
  final AudioHelper _audioHelper = AudioHelper();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _provider = Provider.of<VocabularyProvider>(context, listen: false);
    _audioHelper.preloadSounds();
  }

  void _checkAnswer(WordEntity currentWord, String answer) {
    final isCorrect = answer.trim().toLowerCase() == currentWord.translation.toLowerCase();
    
    _provider.updateProgress(currentWord.id, isCorrect);
    _audioHelper.playSound(isCorrect);

    if (isCorrect) {
      _goToNextPage();
    } else {
      // Show some feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong! Try again.'), duration: Duration(seconds: 1), backgroundColor: Colors.redAccent),
      );
    }
    _answerController.clear();
  }
  
  void _goToNextPage(){
       if (_pageController.page!.toInt() < _provider.trainingList.length - 1) {
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      } else {
        // End of session
        _showSummary();
      }
  }

  void _showSummary() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Session Complete!'),
        content: Consumer<VocabularyProvider>(
            builder: (context, provider, child) {
          if (provider.missedWords.isEmpty) {
            return const Text('Congratulations! You got everything right!');
          }
          return Text('You missed ${provider.missedWords.length} words.');
        }),
        actions: [
          Consumer<VocabularyProvider>(
            builder: (context, provider, child) {
              if (provider.missedWords.isNotEmpty) {
                return TextButton(
                  onPressed: () {
                    provider.retryMissedWords();
                    Navigator.pop(context);
                    _pageController.jumpToPage(0);
                  },
                  child: const Text('Retry Missed Words'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to home
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
        title: const Text('Training'),
      ),
      body: Consumer<VocabularyProvider>(
        builder: (context, provider, child) {
          if (provider.trainingList.isEmpty) {
            return const Center(child: Text('Add some words to start training!'));
          }
          return PageView.builder(
            controller: _pageController,
            itemCount: provider.trainingList.length,
            itemBuilder: (context, index) {
              final word = provider.trainingList[index];
              return _buildTrainingCard(word);
            },
          );
        },
      ),
    );
  }

  Widget _buildTrainingCard(WordEntity word) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            word.original,
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
            decoration: const InputDecoration(hintText: 'Your answer...'),
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
