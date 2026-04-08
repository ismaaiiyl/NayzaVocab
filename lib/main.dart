import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/pages/history_screen.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // --- Hive Initialization ---
  await Hive.initFlutter();
  Hive.registerAdapter(VocabSetModelAdapter());
  Hive.registerAdapter(WordModelAdapter());
  final vocabSetBox = await Hive.openBox<VocabSetModel>('vocab_sets');
  // --- End Hive Initialization ---

  runApp(MyApp(vocabSetBox: vocabSetBox));
}

class MyApp extends StatelessWidget {
  final Box<VocabSetModel> vocabSetBox;
  const MyApp({super.key, required this.vocabSetBox});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // --- SENIOR LEVEL THEME DEFINITION ---
    final ThemeData theme = ThemeData(
      useMaterial3: true,
      primaryColor: const Color(0xFFFFD700), // Electric Gold
      scaffoldBackgroundColor: const Color(0xFFF5F5F7), // Clean white-ish background
      textTheme: GoogleFonts.robotoTextTheme(textTheme).copyWith(
        // For headlines, titles of sets
        displayLarge: GoogleFonts.bebasNeue(textStyle: textTheme.displayLarge, fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
        displayMedium: GoogleFonts.bebasNeue(textStyle: textTheme.displayMedium, fontSize: 36, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
        // For AppBar titles
        headlineLarge: GoogleFonts.roboto(textStyle: textTheme.headlineLarge, fontWeight: FontWeight.w600, color: Colors.black),
        // For list tile titles (word original)
        titleLarge: GoogleFonts.roboto(textStyle: textTheme.titleLarge, fontWeight: FontWeight.w500, fontSize: 18),
        // For list tile subtitles (word translation)
        bodyMedium: GoogleFonts.roboto(textStyle: textTheme.bodyMedium, fontSize: 16, color: Colors.grey.shade700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFFD700), // Electric Gold
        foregroundColor: Colors.black,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        shadowColor: Colors.black26,
      ),
       dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        titleTextStyle: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
    // --- END THEME DEFINITION ---

    return ChangeNotifierProvider(
      create: (_) => VocabSetProvider(vocabSetBox),
      child: MaterialApp(
        title: 'Nayza Vocab',
        debugShowCheckedModeBanner: false, // Hides the debug banner
        theme: theme,
        home: const HistoryScreen(),
      ),
    );
  }
}
