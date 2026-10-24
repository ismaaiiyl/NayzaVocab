import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nayza_vocab/core/theme/app_theme.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/vocab_set_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/word_model.dart';
import 'package:nayza_vocab/features/vocabulary/data/models/folder_model.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/vocab_set_provider.dart';
import 'package:provider/provider.dart';
import 'package:nayza_vocab/core/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nayza_vocab/features/settings/presentation/provider/settings_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/quiz_provider.dart';
import 'package:nayza_vocab/features/vocabulary/presentation/provider/library_provider.dart';
import 'package:nayza_vocab/core/router/app_router.dart';
import 'package:nayza_vocab/l10n/generated/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nayza_vocab/core/constants/supabase_constants.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  // Load environment variables (.env)
  try {
    await dotenv.load(fileName: '.env');
  } catch (e, stack) {
    debugPrint('Dotenv yuklashda ogohlantirish: $e\n$stack');
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(VocabSetModelAdapter());
  Hive.registerAdapter(WordModelAdapter());
  Hive.registerAdapter(FolderModelAdapter());
  final vocabSetBox = await Hive.openBox<VocabSetModel>('vocab_sets');
  final folderBox = await Hive.openBox<FolderModel>('folders');

  // Initialize Notifications
  await NotificationService().init();

  // ✅ FALLBACK: Har ochilishda missed reminder tekshir + alarm yo'qolgan bo'lsa tiklash
  // OEM (Xiaomi, Samsung) app o'ldirganda alarm ketadi — bu recovery mexanizmi
  await NotificationService().checkAndRescheduleOnLaunch();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(vocabSetBox: vocabSetBox, folderBox: folderBox, prefs: prefs));
}

class MyApp extends StatelessWidget {
  final Box<VocabSetModel> vocabSetBox;
  final Box<FolderModel> folderBox;
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.vocabSetBox, required this.folderBox, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => VocabSetProvider(vocabSetBox, folderBox)),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp.router(
            title: 'Nayza Vocab',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            locale: Locale(settings.languageCode),
            routerConfig: AppRouter.getRouter(settings),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
