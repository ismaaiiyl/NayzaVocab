import 'package:flutter/material.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/history_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Register adapters
  if (!Hive.isAdapterRegistered(VocabSetModelAdapter().typeId)) {
    Hive.registerAdapter(VocabSetModelAdapter());
  }
  if (!Hive.isAdapterRegistered(WordModelAdapter().typeId)) {
    Hive.registerAdapter(WordModelAdapter());
  }

  // Open the box for vocab sets
  await Hive.openBox<VocabSetModel>('vocab_sets');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VocabSetProvider(),
      child: MaterialApp(
        title: 'NayzaVocab',
        theme: AppTheme.themeData,
        home: const HistoryScreen(), // Start with HistoryScreen
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
