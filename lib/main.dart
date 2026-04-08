import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/home_page.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(VocabSetModelAdapter());
  Hive.registerAdapter(WordModelAdapter());
  final vocabSetBox = await Hive.openBox<VocabSetModel>('vocab_sets');

  runApp(MyApp(vocabSetBox: vocabSetBox));
}

class MyApp extends StatelessWidget {
  final Box<VocabSetModel> vocabSetBox;
  const MyApp({super.key, required this.vocabSetBox});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VocabSetProvider(vocabSetBox),
      child: MaterialApp(
        title: 'Nayza Vocab',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
