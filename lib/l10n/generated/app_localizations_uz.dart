// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Nayza Vocab';

  @override
  String get homeTitle => 'O\'Z BILIMINGNI SINAB KO\'R!';

  @override
  String get homeSubtitle => 'To\'plamlaringizni tanlang va testni boshlang.';

  @override
  String get startTest => 'TESTNI BOSHLASH';

  @override
  String get matchingGame => 'MATCHING GAME';

  @override
  String get manageCollections => 'TO\'PLAMLARNI BOSHQARISH';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get history => 'To\'plamlar';

  @override
  String get collections => 'To\'plamlar';

  @override
  String get difficultWordsTitle => 'QIYIN SO\'ZLAR';

  @override
  String difficultWordsSubtitle(int count) {
    return 'Sizda $count ta xato qilingan so\'z bor';
  }

  @override
  String difficultSetTitle(int number) {
    return 'Qiyin so\'zlar #$number';
  }

  @override
  String get removeFromDifficult => 'Qiyin so\'zlar ro\'yxatidan olib tashlash';

  @override
  String get noDifficultWords =>
      'Hali qiyin so\'zlar yo\'q. Test ishlashni davom eting!';

  @override
  String get myCollectionsHeader => 'MENING TO\'PLAMLARIM';

  @override
  String get difficultCollectionsHeader => 'QIYIN TO\'PLAMLAR';

  @override
  String get muteOn => 'Ovozni yoqish';

  @override
  String get muteOff => 'Ovozni o\'chirish';

  @override
  String get dataManagement => 'MA\'LUMOTLARNI BOSHQARISH';

  @override
  String get export => 'Export (Zaxiralash)';

  @override
  String get exportSubtitle => 'To\'plamlarni tanlab zaxira qilish';

  @override
  String get import => 'Import (Tiklash)';

  @override
  String get importSubtitle => 'JSON fayldan to\'plamlarni yuklash';

  @override
  String get notifications => 'BILDIRISHNOMALAR';

  @override
  String get dailyReminder => 'Kunlik Eslatma';

  @override
  String reminderSubtitle(String time) {
    return 'Har kuni soat $time da eslatish';
  }

  @override
  String get reminderDefault => 'Har kuni qiyin so\'zlarni eslatish';

  @override
  String reminderSetSuccess(Object time) {
    return 'Kunlik eslatma soat $time ga belgilandi';
  }

  @override
  String get appInfo => 'ILOVA HAQIDA';

  @override
  String get appVersion => 'Nayza Vocab v1.0.1\nCreated for Nayzadorlar 🔱';

  @override
  String get language => 'Til';

  @override
  String get uzbek => 'O\'zbek';

  @override
  String get russian => 'Ruscha';

  @override
  String get english => 'Inglizcha';

  @override
  String importSuccess(Object count) {
    return '$count ta to\'plam muvaffaqiyatli import qilindi';
  }

  @override
  String importError(Object error) {
    return 'Import xatoligi: $error';
  }

  @override
  String get historyTitle => 'TO\'PLAMLARIM';

  @override
  String get searchHint => 'To\'plam yoki so\'zni qidirish...';

  @override
  String get noResults => 'Natija topilmadi';

  @override
  String get noCollections => 'To\'plamlar yo\'q';

  @override
  String get collectionsLabel => 'TO\'PLAMLAR';

  @override
  String get foundWordsLabel => 'TOPILGAN SO\'ZLAR';

  @override
  String get editWord => 'SO\'ZNI TAHRIRLASH';

  @override
  String get editSetTitle => 'TO\'PLAM NOMINI O\'ZGARTIRISH';

  @override
  String get originalWord => 'Asl so\'z';

  @override
  String get translationWord => 'Tarjima';

  @override
  String get cancel => 'BEKOR QILISH';

  @override
  String get save => 'SAQLASH';

  @override
  String get wordUpdated => 'So\'z yangilandi';

  @override
  String wordCountLabel(int count) {
    return '$count so\'z';
  }

  @override
  String get selectCollectionsTitle => 'TO\'PLAMLARNI TANLASH';

  @override
  String get emptyCollectionsWarning =>
      'Avval kamida bitta to\'plam yaratishingiz kerak.';

  @override
  String get selectAll => 'Barchasini tanlash';

  @override
  String get deselectAll => 'Barchasini bekor qilish';

  @override
  String get selectToStart => 'Boshlash uchun tanlang';

  @override
  String get emptySelectionWarning => 'Tanlangan to\'plamlar bo\'sh!';

  @override
  String get quizSetupTitle => 'TEST SOZLAMALARI';

  @override
  String get selectQuizMode => 'TEST TURINI TANLANG';

  @override
  String get selectDirection => 'TEST YO\'NALISHI';

  @override
  String get start => 'BOSHLASH';

  @override
  String get choiceMode => 'Variantli';

  @override
  String get choiceSubtitle => '4 ta javobdan tanlash';

  @override
  String get inputMode => 'Yozma';

  @override
  String get inputSubtitle => 'O\'zingiz kiriting';

  @override
  String get flashcardMode => 'Flashcard';

  @override
  String get flashcardSubtitle => 'Klassik takrorlash';

  @override
  String get matchingMode => 'Matching';

  @override
  String get matchingSubtitle => 'Juftliklarni toping';

  @override
  String get originalToTranslation => 'Asl so\'z -> Tarjima';

  @override
  String get translationToOriginal => 'Tarjima -> Asl so\'z';

  @override
  String get randomDirection => 'Aralash (Random)';

  @override
  String get originalToTranslationSubtitle => 'Masalan: English -> Uzbek';

  @override
  String get translationToOriginalSubtitle => 'Masalan: Uzbek -> English';

  @override
  String get randomDirectionSubtitle => 'Har xil yo\'nalishda';

  @override
  String correctAnswerLabel(String answer) {
    return 'To\'g\'ri javob: $answer';
  }

  @override
  String get typeTranslationHint => 'Tarjimani kiriting...';

  @override
  String get summaryTitle => 'NATIJALAR';

  @override
  String scoreLabel(int score) {
    return 'SIZDAGI BALL: $score';
  }

  @override
  String correctCountLabel(Object count) {
    return 'To\'g\'ri: $count';
  }

  @override
  String incorrectCountLabel(Object count) {
    return 'Xato: $count';
  }

  @override
  String get finish => 'TUGALLASH';

  @override
  String get tryAgain => 'QAYTA URINISH';

  @override
  String learnedWordsCount(Object count) {
    return 'Ushbu sessiyada $count ta so\'zni o\'rgandingiz!';
  }

  @override
  String get flashcardLabel => 'FLASHCARD';

  @override
  String get knowWord => 'BILDIM';

  @override
  String get dontKnowWord => 'BILMADIM';

  @override
  String get matchingGameTitle => 'MOSLASHTIRISH O\'YINI';

  @override
  String get findPairsLabel => 'JUFTLIKLARNI TOPING';

  @override
  String stageLabel(int count) {
    return '$count-bosqich';
  }

  @override
  String get gameOverTitle => 'O\'YIN YAKUNLANDI!';

  @override
  String get createSetTitle => 'YANGI TO\'PLAM';

  @override
  String get collectionNameLabel => 'To\'plam nomi';

  @override
  String get collectionNameHint => 'Masalan: Oila, Sayohat...';

  @override
  String get nameRequiredError => 'Nom kiriting';

  @override
  String get languageLabel => 'O\'rganilayotgan til';

  @override
  String get englishLang => 'Ingliz tili';

  @override
  String get arabicLang => 'Arab tili';

  @override
  String get russianLang => 'Rus tili';

  @override
  String get uzbekLang => 'O\'zbek (Ovozli o\'qish yo\'q)';

  @override
  String get germanLang => 'Nemis';

  @override
  String get koreanLang => 'Koreys';

  @override
  String get wordPlaceholder => 'So\'z';

  @override
  String get translationPlaceholder => 'Tarjima';

  @override
  String get addRowButton => 'QATOR QO\'SHISH';

  @override
  String get atLeastOneWordWarning => 'Kamida bitta so\'z kiriting';

  @override
  String get setNotFound => 'To\'plam topilmadi.';

  @override
  String get deleteSetTitle => 'TO\'PLAMNI O\'CHIRISH';

  @override
  String deleteSetConfirmation(String title) {
    return '\"$title\" to\'plamini o\'chirishga ishonchingiz komilmi?';
  }

  @override
  String get delete => 'O\'CHIRISH';

  @override
  String get addWord => 'SO\'Z QO\'SHISH';

  @override
  String get emptySetWarning => 'Bu to\'plam hali bo\'sh.';

  @override
  String wordsFoundCount(int count) {
    return '$count ta so\'z mavjud';
  }

  @override
  String get masteryExplanation =>
      'So\'z bir marta to\'g\'ri topilganda 100% yodlangan hisoblanadi';

  @override
  String get progressLabel => 'PROGRES';

  @override
  String get selectSetsTitle => 'TO\'PLAMLARNI TANLASH';

  @override
  String get selectAtLeastOneSet => 'Kamida bitta to\'plamni tanlang.';

  @override
  String get exportSuccess => 'Eksport muvaffaqiyatli yakunlandi!';

  @override
  String get shareSuccess => 'To\'plam muvaffaqiyatli ulashildi!';

  @override
  String shareSubject(Object title) {
    return 'NayzaVocab: $title';
  }

  @override
  String shareMessage(Object count, Object lang, Object title) {
    return '📚 Nayza Vocab To\'plami: $title\n🌐 Tili: $lang\n📝 So\'zlar soni: $count ta\n\nUshbu faylni Nayza Vocab amaliyotiga Import qiling va lug\'at boyligingizni oshiring!';
  }

  @override
  String get importedSuffix => '(Import qilingan)';

  @override
  String exportError(String error) {
    return 'Eksportda xatolik: $error';
  }

  @override
  String wordsCountLabel(int count) {
    return '$count ta so\'z';
  }

  @override
  String exportAction(Object count) {
    return 'EKSPORT QILISH ($count)';
  }

  @override
  String get onboardingWelcome => 'NAYZA VOCAB GA XUSH KELIBSIZ';

  @override
  String get onboardingPage1Title => 'So\'zlarni Mukammal O\'rganing';

  @override
  String get onboardingPage1Subtitle =>
      'Ilmiy asoslangan usullar bilan yangi so\'zlarni yodda saqlashning eng samarali yo\'li.';

  @override
  String get onboardingPage2Title => 'Flashcardlar va O\'yinlar';

  @override
  String get onboardingPage2Subtitle =>
      'O\'rganishni qiziqarli qilish uchun mo\'ljallangan interaktiv testlar va moslashtirish o\'yinlari.';

  @override
  String get onboardingPage3Title => 'Progresingizni Kuzating';

  @override
  String get onboardingPage3Subtitle =>
      'Vaqt o\'tishi bilan o\'sishingizni ko\'ring va qiyin so\'zlarga e\'tibor qaratib boring.';

  @override
  String get onboardingGetStarted => 'BOSHLASH';

  @override
  String get skip => 'O\'TKAZIB YUBORISH';

  @override
  String get submitAnswer => 'TASDIQLASH';

  @override
  String get collectionsPageTitle => 'TO\'PLAMLAR';

  @override
  String get cancelReminder => 'Eslatmani bekor qilish';

  @override
  String get resetAllData => 'Barcha ma\'lumotlarni o\'chirish';

  @override
  String get resetAllDataConfirm =>
      'Bu barcha to\'plamlar va progressingizni butunlay o\'chirib tashlaydi. Ishonchingiz komilmi?';

  @override
  String get deleteSetConfirm => 'Ushbu to\'plamni o\'chirishni xohlaysizmi?';
}
