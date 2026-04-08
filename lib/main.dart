import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/home_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocabulary_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  if (!Hive.isAdapterRegistered(WordModelAdapter().typeId)) {
      Hive.registerAdapter(WordModelAdapter());
  }

  await Hive.openBox<WordModel>('words');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VocabularyProvider(),
      child: MaterialApp(
        title: 'NayzaVocab',
        theme: AppTheme.themeData,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
